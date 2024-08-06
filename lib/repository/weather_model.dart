class WeatherModel {
  Location? location;
  CurrentData? current;

  WeatherModel({this.current, this.location});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    final current =
        json['current'] != null ? CurrentData.fromJson(json['current']) : null;
    return WeatherModel(current: current, location: location);
  }

  @override
  String toString() {
    return 'WeatherModel{location: $location, current: $current}';
  }
}

class Location {
  Location(
      {this.name,
      this.region,
      this.country,
      this.latitude,
      this.localTime,
      this.localTimeEpoch,
      this.longitude,
      this.tzId});

  String? name;
  String? region;
  String? country;
  num? latitude;
  num? longitude;
  String? localTime;
  String? tzId;
  num? localTimeEpoch;

  factory Location.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final region = json['region'] as String ?? '';
    final country = json['country'] as String ?? '';
    final latitude = json['lat'] as num? ?? 0;
    final longitude = json['lon'] as num? ?? 0;
    final tzId = json['tz_id'] as String? ?? '';
    final localTime = json['localtime'] as String? ?? '';
    final localTimeEpoch = json['localtime_epoch'] as num? ?? 0;

    return Location(
        country: country,
        latitude: latitude,
        localTime: localTime,
        localTimeEpoch: localTimeEpoch,
        longitude: longitude,
        name: name,
        region: region,
        tzId: tzId);
  }

  @override
  String toString() {
    return 'Location{name: $name, region: $region, country: $country, latitude: $latitude, longitude: $longitude, localTime: $localTime, tzId: $tzId, localTimeEpoch: $localTimeEpoch}';
  }
}

class CurrentData {
  CurrentData(
      {this.airQuality,
      this.cloud,
      this.condition,
      this.feelsLikeCelsius,
      this.feelsLikeFahrenheit,
      this.gustKph,
      this.gustMph,
      this.humidity,
      this.isDay,
      this.lastUpdated,
      this.lastUpdatedEpoch,
      this.precipeIn,
      this.precipeMm,
      this.pressureIn,
      this.pressureMb,
      this.tempCelsius,
      this.tempFahrenheit,
      this.uv,
      this.visKM,
      this.visMile,
      this.windDegree,
      this.windDirection,
      this.windKph,
      this.windMph});

  Condition? condition;
  AirQuality? airQuality;
  num? lastUpdatedEpoch;
  String? lastUpdated;
  num? tempCelsius;
  num? tempFahrenheit;
  num? isDay;
  num? windMph;
  num? windKph;
  num? windDegree;
  String? windDirection;
  num? pressureMb;
  num? pressureIn;
  num? precipeMm;
  num? precipeIn;
  num? humidity;
  num? cloud;
  num? feelsLikeCelsius;
  num? feelsLikeFahrenheit;
  num? visKM;
  num? visMile;
  num? uv;
  num? gustMph;
  num? gustKph;

  factory CurrentData.fromJson(Map<String, dynamic> json) {
    final condition = json['condition'] != null
        ? Condition.fromJson(json['condition'])
        : null;
    final AirQuality? airQuality = json['air_quality'] != null
        ? AirQuality.fromJson(json['air_quality'])
        : null;
    final lastUpdatedEpoch = json['last_updated_epoch'];
    final lastUpdated = json['last_updated'];
    final tempCelsius = json['temp_c'];
    final tempFahrenheit = json['temp_f'];
    final cloud = json['cloud'];
    final isDay = json['is_day'];
    final windMph = json['wind_mph'];
    final windKph = json['wind_kph'];
    final windDegree = json['wind_degree'];
    final windDirection = json['wind_dir'];
    final pressureMb = json['pressure_mb'];
    final pressureIn = json['pressure_in'];
    final precipMm = json['precip_mm'];
    final precipIn = json['precip_in'];
    final humidity = json['humidity'];
    final feelsLikeCelsius = json['feelslike_c'];
    final feelsLikeFahrenheit = json['feelslike_f'];
    final visKm = json['vis_km'];
    final visMiles = json['vis_miles'];
    final uv = json['uv'];
    final gustMph = json['gust_mph'];
    final gustKph = json['gust_kph'];

    return CurrentData(
        airQuality: airQuality,
        condition: condition,
        lastUpdated: lastUpdated,
        lastUpdatedEpoch: lastUpdatedEpoch,
        cloud: cloud,
        feelsLikeCelsius: feelsLikeCelsius,
        feelsLikeFahrenheit: feelsLikeFahrenheit,
        gustKph: gustKph,
        gustMph: gustMph,
        humidity: humidity,
        isDay: isDay,
        precipeIn: precipIn,
        precipeMm: precipMm,
        pressureIn: pressureIn,
        pressureMb: pressureMb,
        tempCelsius: tempCelsius,
        tempFahrenheit: tempFahrenheit,
        uv: uv,
        visKM: visKm,
        visMile: visMiles,
        windDegree: windDegree,
        windDirection: windDirection,
        windKph: windKph,
        windMph: windMph);
  }

  @override
  String toString() {
    return 'CurrentData{condition: $condition, airQuality: $airQuality, lastUpdatedEpoch: $lastUpdatedEpoch, lastUpdated: $lastUpdated, tempCelsius: $tempCelsius, tempFahrenheit: $tempFahrenheit, isDay: $isDay, windMph: $windMph, windKph: $windKph, windDegree: $windDegree, windDirection: $windDirection, pressureMb: $pressureMb, pressureIn: $pressureIn, precipeMm: $precipeMm, precipeIn: $precipeIn, humidity: $humidity, cloud: $cloud, feelsLikeCelsius: $feelsLikeCelsius, feelsLikeFahrenheit: $feelsLikeFahrenheit, visKM: $visKM, visMile: $visMile, uv: $uv, gustMph: $gustMph, gustKph: $gustKph}';
  }
}

class Condition {
  Condition({this.text, this.icon, this.code});

  String? text;
  String? icon;
  num? code;

  factory Condition.fromJson(Map<String, dynamic> json) {
    final text = json['text'] as String? ?? '';
    final icon = json['icon'] as String? ?? '';
    final code = json['code'] as num? ?? 0;
    return Condition(code: code, icon: icon, text: text);
  }

  @override
  String toString() {
    return 'Condition{text: $text, icon: $icon, code: $code}';
  }
}

class AirQuality {
  AirQuality(
      {this.coQuantity,
      this.no2Quantity,
      this.so2Quantity,
      this.o3Quality,
      this.pm25,
      this.pm10,
      this.epaIndex,
      this.gbIndex});

  num? coQuantity;
  num? no2Quantity;
  num? so2Quantity;
  num? o3Quality;
  num? pm25;
  num? pm10;
  num? epaIndex;
  num? gbIndex;

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final coQuantity = json['co'];
    final no2Quantity = json['no2'];
    final so2Quantity = json['so2'];
    final o3Quality = json['o3'];
    final pm25 = json['pm2_5'];
    final pm10 = json['pm10'];
    final epaIndex = json['us-epa-index'];
    final gbIndex = json['gb-defra-index'];

    return AirQuality(
        coQuantity: coQuantity,
        no2Quantity: no2Quantity,
        so2Quantity: so2Quantity,
        o3Quality: o3Quality,
        pm25: pm25,
        pm10: pm10,
        epaIndex: epaIndex,
        gbIndex: gbIndex);
  }

  @override
  String toString() {
    return 'AirQuality{coQuantity: $coQuantity, no2Quantity: $no2Quantity, so2Quantity: $so2Quantity, o3Quality: $o3Quality, pm25: $pm25, pm10: $pm10, epaIndex: $epaIndex, gbIndex: $gbIndex}';
  }
}
