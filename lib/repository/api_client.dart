import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location_permission_weather/repository/weather_model.dart';

class ApiClient {
  ApiClient._internal();
  static final instance = ApiClient._internal();

  Future<(String? location, String? temprature)> getWeatherData(
      String cityLocation) async {
    final url =
        'https://api.weatherapi.com/v1/current.json?q=$cityLocation&key=1bc3b2cbce2d424eb8a51410240107';
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final model = WeatherModel.fromJson(json);
      return (
        model.location?.name.toString(),
        model.current?.tempCelsius.toString()
      );
    } else {
      print('else part : ${response.statusCode}');
      return (null, null);
    }
  }
}
