import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';
import '../cubit/LocationCubit.dart';
import '../cubit/LocationState.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(),
      child: const LocationView(),
    );
  }
}

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: themeColor),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Your ",
                    style: GoogleFonts.workSans(
                      color: themeColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: themeColor.withOpacity(0.8),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  TextSpan(
                    text: "Location",
                    style: GoogleFonts.workSans(
                      color: AppColors.instance.cyanAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: AppColors.instance.cyanAccent.withOpacity(0.8),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: BlocConsumer<LocationCubit, LocationState>(
            listener: (context, state) {
              if (state.status == LocationStatus.success && _mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(state.initialPosition, 15),
                );
              }
            },
            builder: (context, state) {
              if (state.status == LocationStatus.loading) {
                return Center(child: CircularProgressIndicator(color: AppColors.instance.cyanAccent));
              }

              if (state.status == LocationStatus.error || state.status == LocationStatus.permissionDenied) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage ?? "An error occurred",
                        style: GoogleFonts.workSans(color: themeColor),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context.read<LocationCubit>().getCurrentLocation(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              return GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (state.status == LocationStatus.success) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(state.initialPosition, 15),
                    );
                  }
                },
                initialCameraPosition: CameraPosition(
                  target: state.initialPosition,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                style: isDark ? null : null, // Future: add light/dark map styles here
              );
            },
          ),
        );
      },
    );
  }
}
