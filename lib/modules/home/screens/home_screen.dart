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
  TextEditingController locationController = TextEditingController();
  bool isChanging = false;
  String? city;

  Future<String?> getLocation() async {
    try {
      Position? position = await Geolocator.getCurrentPosition();
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placeMarks[0].locality;
    } catch (e) {
      print('placemark error.....${e.toString()}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) async {
        print('mari permission : ${state.permissionStatus}');
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
          city = await getLocation();
          context.read<WeatherCubit>().getWeatherData(city ?? 'Delhi');
        } else if (state.permissionStatus == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required.'),
            ),
          );
        } else if (state.permissionStatus == LocationPermission.deniedForever) {
          print('permanentlyDenied ; must show dialogue');
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
                            isChanging = true;
                          });
                        },
                        controller: locationController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter Location',
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isChanging
                                  ? IconButton(
                                      onPressed: () {
                                        locationController.clear();
                                        setState(() {
                                          isChanging = false;
                                        });
                                      },
                                      icon: const Icon(Icons.cancel_outlined),
                                    )
                                  : const SizedBox(),
                              IconButton(
                                onPressed: () async {
                                  await context
                                      .read<LocationCubit>()
                                      .requestLocationPermission();
                                  if (city != null) {
                                    locationController.text = city!;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Could not fetch your current location. Please try again later'),
                                      ),
                                    );
                                  }
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
                          .getWeatherData(locationController.text);
                    },
                    child: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      return state.status == WeatherStateStatus.initial
                          ? const Text('Know the current Weather')
                          : state.status == WeatherStateStatus.loading
                              ? const CircularProgressIndicator()
                              : state.status == WeatherStateStatus.loaded
                                  ? Column(
                                      children: [
                                        Text('City : ${state.location}'),
                                        const SizedBox(height: 10),
                                        Text(
                                            'weather : ${state.temp} degree celsius')
                                      ],
                                    )
                                  : const Text('Please try again');
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
