import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import '../../../core/utils/consts/AppColors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';

void showBugReportDialog(BuildContext context, SettingsCubit cubit) {
  final TextEditingController bugReportController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: cubit,
        child: BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state.status == SettingsStatus.success) {
              toastification.show(
                context: context,
                type: ToastificationType.info,
                title: Text(
                  state.bugReportStatus ?? 'Success',
                  style: GoogleFonts.workSans(fontWeight: FontWeight.bold),
                ),
                autoCloseDuration: const Duration(seconds: 4),
              );
              Navigator.pop(context);
              cubit.resetStatus();
            } else if (state.status == SettingsStatus.error) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: Text(
                  state.errorMessage ?? 'Error',
                  style: GoogleFonts.workSans(fontWeight: FontWeight.bold),
                ),
                autoCloseDuration: const Duration(seconds: 4),
              );
              cubit.resetStatus();
            }
          },
          child: AlertDialog(
            backgroundColor: AppColors.instance.shadeblack,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            title: Text(
              'Report a Bug',
              style: GoogleFonts.workSans(
                fontWeight: FontWeight.bold,
                color: AppColors.instance.white,
              ),
            ),
            content: TextField(
              controller: bugReportController,
              style: GoogleFonts.workSans(color: AppColors.instance.white),
              decoration: InputDecoration(
                hintText: 'Describe the bug...',
                hintStyle: GoogleFonts.workSans(color: AppColors.instance.gray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.instance.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.instance.cyanAccent, width: 2.0),
                ),
                filled: true,
                fillColor: AppColors.instance.black,
              ),
              maxLines: 4,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.workSans(color: AppColors.instance.white),
                ),
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state.status == SettingsStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return TextButton(
                    onPressed: () {
                      cubit.reportBug(bugReportController.text);
                    },
                    child: Text(
                      'Submit',
                      style: GoogleFonts.workSans(
                        color: AppColors.instance.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
