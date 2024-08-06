import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_permission_weather/repository/api_client.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit()
      : super(const WeatherState(status: WeatherStateStatus.initial));

  Future<void> getWeatherData(String cityLocation) async {
    try {
      emit(state.copyWith(status: WeatherStateStatus.initial));
      final data = await ApiClient().getModel(cityLocation);
      String? location = data?.location?.name.toString();
      String? temp = data?.current?.tempCelsius.toString();
      emit(
        state.copyWith(
          status: WeatherStateStatus.weatherLoaded,
          location: location,
          temp: temp,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: WeatherStateStatus.hasError));
    }
  }
}
