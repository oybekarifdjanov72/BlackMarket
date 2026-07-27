import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LocationStatus { initial, loading, success, error, permissionDenied }

class LocationState extends Equatable {
  final LatLng initialPosition;
  final LocationStatus status;
  final String? errorMessage;

  const LocationState({
    this.initialPosition = const LatLng(37.4219999, -122.0840575), // default to Googleplex
    this.status = LocationStatus.initial,
    this.errorMessage,
  });

  LocationState copyWith({
    LatLng? initialPosition,
    LocationStatus? status,
    String? errorMessage,
  }) {
    return LocationState(
      initialPosition: initialPosition ?? this.initialPosition,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [initialPosition, status, errorMessage];
}
