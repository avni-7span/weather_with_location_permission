import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState(status: PermissionStatus.denied));

  Future<void> locationPermissionHandler() async {
    await Permission.location.request();
    final status = await Permission.location.status;
    emit(state.copyWith(status: status));
    if (await Permission.location.serviceStatus.isEnabled) {
      emit(state.copyWith(isLocationEnabled: true));
    }
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      emit(state.copyWith(isLocationInUseEnabled: true));
    }
    await Permission.location
        .onGrantedCallback(
          () => emit(
            state.copyWith(status: PermissionStatus.granted),
          ),
        )
        .onDeniedCallback(
          () => emit(
            state.copyWith(status: PermissionStatus.denied),
          ),
        )
        .onPermanentlyDeniedCallback(
          () => emit(
            state.copyWith(status: PermissionStatus.permanentlyDenied),
          ),
        )
        .onRestrictedCallback(
          () => emit(
            state.copyWith(status: PermissionStatus.granted),
          ),
        );
  }
}
