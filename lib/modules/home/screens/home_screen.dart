import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permission_weather/modules/location/location_cubit.dart';
import 'package:location_permission_weather/modules/weather/cubit/weather_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _locationController = TextEditingController();
  String? _textFieldValue;

  Future<String?> getLocation() async {
    try {
      Position? position = await Geolocator.getCurrentPosition();
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placeMarks[0].locality;
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) async {
        if (!state.isLocationEnabled!) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: const Text(
                    'Location must be enabled to fetch weather of current location'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Open Settings'),
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                      final permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.whileInUse ||
                          permission == LocationPermission.always) {
                        Navigator.pop(_);
                      }
                      await context
                          .read<LocationCubit>()
                          .requestLocationPermission();
                    },
                  ),
                ],
              );
            },
          );
        }
        if (state.isLocationEnabled! &&
            (state.permissionStatus == LocationPermission.whileInUse ||
                state.permissionStatus == LocationPermission.always)) {
          final city = await getLocation();
          context.read<WeatherCubit>().getWeatherData(city ?? '');
          _locationController.text = city ?? 'Could not fetch location';
        } else if (state.permissionStatus == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required.'),
            ),
          );
        } else if (state.permissionStatus == LocationPermission.deniedForever) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: const Text(
                    'Application requires location access to fetch weather of current location'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Open Settings'),
                    onPressed: () async {
                      await openAppSettings();
                      final permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.whileInUse ||
                          permission == LocationPermission.always) {
                        Navigator.pop(_);
                      }
                      await context
                          .read<LocationCubit>()
                          .requestLocationPermission();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: BlocListener<WeatherCubit, WeatherState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == WeatherStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went wrong'),
              ),
            );
          } else if (state.status == WeatherStateStatus.nullCity) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter location for weather data'),
              ),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      return TextFormField(
                        onChanged: (_) {
                          setState(() {
                            _textFieldValue = _locationController.text;
                          });
                        },
                        controller: _locationController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter Location',
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_textFieldValue != '')
                                IconButton(
                                  onPressed: () {
                                    _locationController.clear();
                                    setState(() {
                                      _textFieldValue = '';
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_outlined),
                                )
                              else
                                const SizedBox(),
                              IconButton(
                                onPressed: () async {
                                  await context
                                      .read<LocationCubit>()
                                      .requestLocationPermission();
                                },
                                icon: const Icon(Icons.my_location),
                                tooltip: 'Weather at your current location',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<WeatherCubit>()
                          .getWeatherData(_locationController.text);
                    },
                    child: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      if (state.status == WeatherStateStatus.initial) {
                        return const Text('Know the current Weather');
                      } else if (state.status == WeatherStateStatus.nullCity) {
                        return const Text('');
                      } else if (state.status == WeatherStateStatus.loading) {
                        return const CircularProgressIndicator();
                      } else if (state.status == WeatherStateStatus.loaded) {
                        return Column(
                          children: [
                            Text('City  :  ${state.location}'),
                            const SizedBox(height: 10),
                            Text('weather  :  ${state.temp} \u2103')
                          ],
                        );
                      } else {
                        return const Text('Please try again');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
