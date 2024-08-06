part of 'weather_cubit.dart';

enum WeatherStateStatus { initial, fetchingWeather, hasError, weatherLoaded }

class WeatherState extends Equatable {
  const WeatherState({required this.status, this.location, this.temp});

  final WeatherStateStatus status;
  final String? location;
  final String? temp;

  @override
  List<Object?> get props => [status, location, temp];

  WeatherState copyWith({
    WeatherStateStatus? status,
    String? location,
    String? temp,
  }) {
    return WeatherState(
      status: status ?? this.status,
      location: location ?? this.location,
      temp: temp ?? this.temp,
    );
  }
}
