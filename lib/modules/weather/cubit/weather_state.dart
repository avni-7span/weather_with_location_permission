part of 'weather_cubit.dart';

enum WeatherStateStatus { initial, loading, error, loaded, nullCity }

class WeatherState extends Equatable {
  const WeatherState({
    this.status = WeatherStateStatus.initial,
    this.location = '',
    this.temp = '',
  });

  final WeatherStateStatus status;
  final String location;
  final String temp;

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

  @override
  List<Object?> get props => [status, location, temp];
}
