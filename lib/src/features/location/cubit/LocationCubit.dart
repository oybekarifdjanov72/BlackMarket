import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'LocationState.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState()) {
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(status: LocationStatus.loading));
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(status: LocationStatus.error, errorMessage: "Location services are disabled."));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(status: LocationStatus.permissionDenied, errorMessage: "Location permissions are denied."));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(status: LocationStatus.permissionDenied, errorMessage: "Location permissions are permanently denied."));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      emit(state.copyWith(
        status: LocationStatus.success,
        initialPosition: LatLng(position.latitude, position.longitude),
      ));
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.error, errorMessage: e.toString()));
    }
  }
}
