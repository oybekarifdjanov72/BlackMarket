import 'package:black_market/src/core/validators/AppValidators.dart';
import 'package:black_market/src/core/widget/CustomTextFormFIeld.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import '../../../core/service/GoogleService.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../../../core/utils/consts/AppRouter.dart';
import '../../../core/widget/CustomAppButton.dart';
import '../cubit/AuthCubit.dart';
import '../cubit/AuthState.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);
        final containerColor = AppColors.instance.getCardBackground(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: bgColor,
            title: Text.rich(
              TextSpan(
                style: GoogleFonts.workSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "Create ",
                    style: TextStyle(
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
                    text: "Account",
                    style: TextStyle(
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
          ),
          body: BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return previous.runtimeType != current.runtimeType;
            },
            listener: (context, state) {
              if (state is AuthError) {
                toastification.show(
                  type: ToastificationType.error,
                  autoCloseDuration: Duration(seconds: 3),
                  title: Text(
                    state.message,
                    style: GoogleFonts.workSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is AuthLoaded) {
                toastification.show(
                  type: ToastificationType.success,
                  autoCloseDuration: Duration(seconds: 3),
                  title: Text(
                    "Successfully authorized",
                    style: GoogleFonts.workSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                );
                AppRouter.pushAndRemoveUntil(context, AppRoutes.bottomNav, (_) => false);
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "Join the Black Market,",
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: themeColor,
                            ),
                          ),
                          Text(
                            "and start purchasing",
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: containerColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hintText: "Enter your full name",
                                    labelText: "Full Name",
                                    controller: fullNameController,
                                    validator: Validators.required,
                                    isPassword: false,
                                    prefixIcon: CupertinoIcons.person,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    hintText: "Enter your email",
                                    labelText: "Email",
                                    controller: emailController,
                                    validator: Validators.email,
                                    isPassword: false,
                                    prefixIcon: CupertinoIcons.mail,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    hintText: "Enter your password",
                                    labelText: "Password",
                                    controller: passwordController,
                                    validator: Validators.password,
                                    isPassword: true,
                                    prefixIcon: CupertinoIcons.lock,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    hintText: "Confirm your password",
                                    labelText: "Confirm Password",
                                    controller: confirmPasswordController,
                                    validator: (value) => Validators.confirmPassword(
                                      value,
                                      passwordController.text,
                                    ),
                                    isPassword: true,
                                    prefixIcon: CupertinoIcons.lock,
                                  ),
                                  const SizedBox(height: 20),
                                  state is AuthLoading
                                      ? const CupertinoActivityIndicator()
                                      : AppButton(
                                    onTap: () {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }
                                      context.read<AuthCubit>().signUp(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        fullName: fullNameController.text,
                                      );
                                    },
                                    text: 'Sign Up',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "Or continue with",
                            style: GoogleFonts.workSans(
                              fontSize: 16,
                              color: AppColors.instance.gray,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Spacer(),
                              OutlinedButton(
                                onPressed: () async {
                                  final user = await GoogleAuthService.signInWithGoogle(
                                    true,
                                  );
                                  if (user != null) {
                                    debugPrint("Success: ${user.email}");
                                    if (context.mounted) {
                                      AppRouter.pushReplacement(
                                        context,
                                        AppRoutes.home,
                                      );
                                    }
                                  } else {
                                    debugPrint("Google sign in failed");
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: containerColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: themeColor.withOpacity(0.1)),
                                  ),
                                  fixedSize: const Size(150, 50),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle_outlined,
                                      size: 24,
                                      color: themeColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Google",
                                      style: GoogleFonts.workSans(
                                        color: themeColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: containerColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: themeColor.withOpacity(0.1)),
                                  ),
                                  fixedSize: const Size(150, 50),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.facebook,
                                      size: 24,
                                      color: themeColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Facebook",
                                      style: GoogleFonts.workSans(
                                        color: themeColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TextButton(
                              onPressed: () {
                                AppRouter.push(context, AppRoutes.signIn);
                              },
                              child: Text(
                                "Already have an account?",
                                style: GoogleFonts.workSans(
                                  color: AppColors.instance.gray,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
