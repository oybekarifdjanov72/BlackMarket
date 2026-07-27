import 'dart:io';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/consts/AppColors.dart';
import '../../../core/utils/consts/AppRouter.dart';
import '../../settings/widget/SettingsItem.dart';
import '../cubit/ProfileCubit.dart';
import '../cubit/ProfileState.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context, Color themeColor, Color bgColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Are you sure to leave?",
          style: GoogleFonts.workSans(
            color: themeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: GoogleFonts.workSans(
                color: themeColor.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pop(context);
                AppRouter.pushAndRemoveUntil(context, AppRoutes.splash, (_) => false);
              }
            },
            child: Text(
              "Yes",
              style: GoogleFonts.workSans(
                color: AppColors.instance.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.success && state.user != null) {
              if (!isEditing) {
                nameController.text = state.user!.fullName;
              }
            }
            if (state.status == ProfileStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? "An error occurred")),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final isDark = settingsState.isDarkMode;
          final themeColor = AppColors.instance.getTextPrimary(isDark);
          final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);
          final bgColor = AppColors.instance.getBackground(isDark);

          return Scaffold(
            backgroundColor: bgColor,
            body: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final user = state.user;
                final fullName = user?.fullName ?? currentUser?.displayName ?? "Your Name";
                final email = user?.email ?? currentUser?.email ?? "No email";
                final photoUrl = user?.photoUrl ?? currentUser?.photoURL;
                final localPath = state.localImagePath;

                return SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: AppColors.instance.gray.withOpacity(0.3),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 45,
                                      color: themeColor,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Your ',
                                        style: GoogleFonts.workSans(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: themeColor,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: themeColor.withOpacity(0.8),
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Profile',
                                        style: GoogleFonts.workSans(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.instance.cyanAccent,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: AppColors.instance.cyanAccent.withOpacity(0.8),
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(width: 45), 
                              ],
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () => context.read<ProfileCubit>().pickAndUploadImage(),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    key: ValueKey(localPath ?? photoUrl), 
                                    radius: 70,
                                    backgroundColor: isDark ? AppColors.instance.white : AppColors.instance.black,
                                    backgroundImage: localPath != null 
                                        ? FileImage(File(localPath)) as ImageProvider
                                        : (photoUrl != null ? NetworkImage(photoUrl) : null),
                                    child: (photoUrl == null && localPath == null)
                                        ? Icon(CupertinoIcons.person, size: 50, color: isDark ? AppColors.instance.black : AppColors.instance.white)
                                        : null,
                                  ),
                                  if (state.status == ProfileStatus.loading)
                                    SizedBox(
                                      width: 140,
                                      height: 140,
                                      child: CircularProgressIndicator(color: AppColors.instance.cyanAccent, strokeWidth: 3),
                                    ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: AppColors.instance.cyanAccent,
                                      child: Icon(Icons.camera_alt, size: 22, color: AppColors.instance.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            isEditing
                                ? TextField(
                              controller: nameController,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.workSans(
                                fontSize: 28,
                                color: themeColor,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: "Enter your name",
                                hintStyle: GoogleFonts.workSans(color: themeColorSecondary),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor.withOpacity(0.38)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                              ),
                            )
                                : Text(
                              fullName,
                              style: GoogleFonts.workSans(
                                fontSize: 30,
                                color: themeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email,
                              style: GoogleFonts.workSans(
                                fontSize: 18,
                                color: themeColorSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (currentUser?.emailVerified ?? false)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified, size: 20, color: AppColors.instance.greenAccent),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Verified Account",
                                      style: GoogleFonts.workSans(
                                        color: AppColors.instance.greenAccent, 
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 35),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (isEditing) {
                                      context.read<ProfileCubit>().updateProfile(fullName: nameController.text);
                                      setState(() {
                                        isEditing = false;
                                      });
                                    } else {
                                      setState(() {
                                        isEditing = true;
                                        nameController.text = fullName;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: bgColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 15,
                                    ),
                                    side: BorderSide(color: themeColor, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: const Size(160, 55),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isEditing ? Icons.save_alt_outlined : Icons.mode_edit_outline_outlined,
                                        size: 24,
                                        color: themeColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        isEditing ? "SAVE" : "EDIT PROFILE",
                                        style: GoogleFonts.workSans(
                                          fontSize: 14,
                                          color: themeColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    final message = 'Hello! This is my profile:\n\nName: $fullName\nEmail: $email';
                                    Share.share(message);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: bgColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 15,
                                    ),
                                    side: BorderSide(color: themeColor, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: const Size(160, 55),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.share, size: 24, color: themeColor),
                                      const SizedBox(width: 10),
                                      Text(
                                        "SHARE",
                                        style: GoogleFonts.workSans(
                                          fontSize: 14,
                                          color: themeColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Opportunities",
                                style: GoogleFonts.workSans(
                                  fontSize: 24,
                                  color: themeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            SettingsItem(
                              text: "Purchase History",
                              icon: Icons.history_outlined,
                              onTap: () {
                                AppRouter.push(context, AppRoutes.purchaseHistory);
                              },
                            ),
                            const SizedBox(height: 15),
                            SettingsItem(
                              text: "Update Service",
                              icon: Icons.browser_updated_outlined,
                              onTap: () {
                                context.read<ProfileCubit>().getProfile();
                              },
                            ),
                            const SizedBox(height: 40),
                            if (currentUser != null) ...[
                              Text(
                                "Last Sign In: ${currentUser.metadata.lastSignInTime?.toLocal().toString().split('.')[0] ?? 'Unknown'}",
                                style: GoogleFonts.workSans(
                                  color: themeColorSecondary, 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                            TextButton.icon(
                              onPressed: () => _showLogoutDialog(context, themeColor, bgColor),
                              icon: Icon(Icons.logout, color: AppColors.instance.red, size: 30),
                              label: Text(
                                'LOG OUT',
                                style: GoogleFonts.workSans(
                                  color: AppColors.instance.red, 
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
