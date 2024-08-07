import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_permission_weather/repository/api_client.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(const WeatherState());

  Future<void> getWeatherData(String cityLocation) async {
    try {
      emit(state.copyWith(status: WeatherStateStatus.loading));

      final (location, temp) =
          await ApiClient.instance.getWeatherData(cityLocation);

      emit(
        state.copyWith(
          status: WeatherStateStatus.loaded,
          location: location,
          temp: temp,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: WeatherStateStatus.error));
    }
  }
}
