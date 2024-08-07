import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState());

  // function to check if user has granted location permissions are
  Future<bool> requestLocationPermission() async {
    late bool serviceEnabled;
    late LocationPermission permission;

    emit(state.copyWith(status: LocationStateStatus.loading));
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      /// Phone don't have location feature
      emit(state.copyWith(isLocationEnabled: false));
      return Future.error('Location services are disabled.');
    } else {
      emit(state.copyWith(isLocationEnabled: true));
      print('islocation enabled ....?: ${state.isLocationEnabled}');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      log('permission 1: $permission');
      emit(state.copyWith(
          permissionStatus: permission, status: LocationStateStatus.loaded));
    } else if (permission == LocationPermission.deniedForever) {
      log('permission 5: $permission');
      emit(state.copyWith(
          permissionStatus: permission, status: LocationStateStatus.loaded));
    } else if (permission == LocationPermission.denied) {
      // permission = await Geolocator.requestPermission();
      // log('permission 2: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        log('permission 3: $permission');
        emit(state.copyWith(
            permissionStatus: permission, status: LocationStateStatus.loaded));
      } else {
        log('permission 4: $permission');
        emit(state.copyWith(
            permissionStatus: permission, status: LocationStateStatus.loaded));
      }
    }

    return true;
  }
}
