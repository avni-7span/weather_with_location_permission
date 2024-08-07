part of 'location_cubit.dart';

enum LocationStateStatus { loading, loaded, initial }

class LocationState extends Equatable {
  const LocationState({
    this.permissionStatus = LocationPermission.unableToDetermine,
    this.isLocationEnabled,
    this.status = LocationStateStatus.initial,
  });

  final LocationPermission permissionStatus;
  final bool? isLocationEnabled;
  final LocationStateStatus status;

  @override
  List<Object?> get props => [permissionStatus, isLocationEnabled, status];

  LocationState copyWith({
    LocationPermission? permissionStatus,
    bool? isLocationEnabled,
    LocationStateStatus? status,
  }) {
    return LocationState(
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      status: status ?? this.status,
    );
  }
}
