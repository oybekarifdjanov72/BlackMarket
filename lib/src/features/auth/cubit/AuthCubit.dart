import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

import 'AuthState.dart';

class AuthCubit extends Cubit<AuthState> {
  String verificationId = "";

  AuthCubit() : super(AuthInitial());

  Future<void> signUp({required String email, required String password, required String fullName}) async {
    emit(AuthLoading());
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set({
          'uid': result.user!.uid,
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (result.user != null) {
        emit(AuthLoaded());
      } else {
        emit(AuthError(message: 'Something went wrong !'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Something went wrong !'));
    } catch (error) {
      emit(AuthError(message: 'Something went wrong !'));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        emit(AuthLoaded());
      } else {
        emit(AuthError(message: 'Something went wrong !'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Something went wrong !'));
    } catch (error) {
      emit(AuthError(message: 'Something went wrong !'));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(AuthPasswordResetSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Something went wrong !'));
    } catch (error) {
      emit(AuthError(message: 'Something went wrong !'));
    }
  }

  Future<void> checkSmsCode({
    required String smsCode,
    required String verificationId,
  }) async {
    emit(AuthLoading());

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final result = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (result.user != null) {
        emit(AuthOtpSuccess());
      }
      print("success");
    } on FirebaseAuthException catch (e) {
      emit(AuthError(
        message: e.message ?? 'Something went wrong!',
      ));
    } catch (e) {
      print("error $e");
    }
  }
}

void logOut() async {
  await FirebaseAuth.instance.signOut();
}
