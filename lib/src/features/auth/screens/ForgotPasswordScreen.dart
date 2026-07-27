import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:toastification/toastification.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../../../core/validators/AppValidators.dart';
import '../../../core/widget/CustomAppButton.dart';
import '../../../core/widget/CustomTextFormField.dart';
import '../cubit/AuthCubit.dart';
import '../cubit/AuthState.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final phoneMask = MaskTextInputFormatter(
    mask: '##-###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.instance.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.instance.black,
        title: Text(
          "Forgot password?",
          style: GoogleFonts.workSans(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: AppColors.instance.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: BlocListener<AuthCubit, AuthState>(
              listenWhen: (previous, current) {
                return previous.runtimeType != current.runtimeType;
              },
              listener: (context, state) {
                if (state is AuthPasswordResetSuccess) {
                  toastification.show(
                    type: ToastificationType.success,
                    title: Text(
                      "Check your email!",
                      style: GoogleFonts.workSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  );
                } else if (state is AuthError) {
                  toastification.show(
                    type: ToastificationType.error,
                    title: Text(
                      state.message,
                      style: GoogleFonts.workSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius
                      .circular(12), color: AppColors.instance.white,),
                  child: Column(
                    children: [
                            CustomTextField(
                              hintText: "Enter your email!",
                              labelText: "Email",
                              controller: emailController,
                              prefixIcon: CupertinoIcons.mail,
                              validator: Validators.email,
                            ),
                    SizedBox(height: 30),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return CupertinoActivityIndicator();
                        }
                        return AppButton(
                          onTap: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            context.read<AuthCubit>().forgotPassword(
                              email: emailController.text,
                            );
                          },
                          text: "Reset",
                        );
                      },
                    ),
                  ],
                ),
                ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
