part of 'location_cubit.dart';

// enum LocationStateStatus { granted, permanentlyDenied, initial }

class LocationState extends Equatable {
  const LocationState(
      {required this.status,
      this.isLocationEnabled = false,
      this.isLocationInUseEnabled = false});

  final PermissionStatus status;
  final bool isLocationEnabled;
  final bool isLocationInUseEnabled;

  @override
  List<Object?> get props =>
      [status, isLocationEnabled, isLocationInUseEnabled];

  LocationState copyWith({
    PermissionStatus? status,
    bool? isLocationEnabled,
    bool? isLocationInUseEnabled,
  }) {
    return LocationState(
      status: status ?? this.status,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      isLocationInUseEnabled:
          isLocationInUseEnabled ?? this.isLocationInUseEnabled,
    );
  }
}
