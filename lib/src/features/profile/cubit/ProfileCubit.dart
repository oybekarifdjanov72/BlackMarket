import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/model/ProfileModel.dart';
import 'ProfileState.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState()) {
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(state.copyWith(status: ProfileStatus.error, errorMessage: "No user logged in"));
        return;
      }

      final uid = currentUser.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final user = ProfileModel.fromJson(doc.data()!);
        emit(state.copyWith(status: ProfileStatus.success, user: user));
      } else {
        final user = ProfileModel(
          fullName: currentUser.displayName ?? "Your Name",
          email: currentUser.email ?? "No email",
          photoUrl: currentUser.photoURL,
        );
        emit(state.copyWith(status: ProfileStatus.success, user: user));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateProfile({String? fullName, String? photoUrl}) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (fullName != null) await user.updateDisplayName(fullName);
        if (photoUrl != null) await user.updatePhotoURL(photoUrl);

        final uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fullName': fullName ?? user.displayName,
          'email': user.email,
          'photoUrl': photoUrl ?? user.photoURL,
        }, SetOptions(merge: true));

        await user.reload();
        await getProfile();
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        
        emit(state.copyWith(localImagePath: path, status: ProfileStatus.loading));
        
        final file = File(path);
        final user = FirebaseAuth.instance.currentUser;
        
        if (user != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_profiles')
              .child('${user.uid}.jpg');

          await storageRef.putFile(file);
          final downloadUrl = await storageRef.getDownloadURL();

          await updateProfile(photoUrl: downloadUrl);
          emit(state.copyWith(localImagePath: null));
        }
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: "Error uploading image: $e"));
    }
  }
}
