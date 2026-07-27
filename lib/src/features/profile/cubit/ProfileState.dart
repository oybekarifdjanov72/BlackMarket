import 'package:equatable/equatable.dart';
import '../../../core/model/ProfileModel.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileModel? user;
  final String? errorMessage;
  final String? localImagePath; // To show image instantly before upload finishes

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
    this.localImagePath,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileModel? user,
    String? errorMessage,
    String? localImagePath,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, localImagePath];
}
