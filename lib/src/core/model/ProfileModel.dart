class ProfileModel {
  final String fullName;
  final String email;
  final String? photoUrl;

  ProfileModel({
    required this.fullName,
    required this.email,
    this.photoUrl,
  });

  ProfileModel copyWith({
    String? email,
    String? fullName,
    String? photoUrl,
  }) {
    return ProfileModel(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
