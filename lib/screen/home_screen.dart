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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TextEditingController locationController = TextEditingController();

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<LocationCubit>().locationPermissionHandler();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (!state.isLocationEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable the location'),
            ),
          );
        } else if (state.isLocationInUseEnabled ||
            state.status == PermissionStatus.granted &&
                state.isLocationEnabled) {
          final String? city = await getLocation();
          context.read<WeatherCubit>().getWeatherData(city ?? 'Delhi');
        } else if (state.status == PermissionStatus.permanentlyDenied) {
          print('permanentlyDenied ; must show dialogue');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text(
                    'Location access is required to fetch weather of current location'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const TextButton(
                    child: Text('Open Settings'),
                    onPressed: openAppSettings,
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
          if (state.status == WeatherStateStatus.hasError) {
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
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Location'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<WeatherCubit>()
                          .getWeatherData(locationController.text);
                    },
                    child: const Icon(
                      Icons.search,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LocationCubit>().locationPermissionHandler();
                    },
                    child: const Text('Know weather at your location'),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      return state.status == WeatherStateStatus.initial
                          ? const Text('Know the current Weather')
                          : state.status == WeatherStateStatus.fetchingWeather
                              ? const CircularProgressIndicator()
                              : state.status == WeatherStateStatus.weatherLoaded
                                  ? Column(
                                      children: [
                                        Text('City : ${state.location}'),
                                        const SizedBox(height: 10),
                                        Text('weather : ${state.temp}')
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
