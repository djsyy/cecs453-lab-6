import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'weather_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Weather App', home: WeatherScreen());
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController cityController = TextEditingController();
  final WeatherService weatherService = WeatherService();

  bool isLoading = false;
  String? weatherCity;
  double? temperature;
  String? weatherDescription;
  String? weatherIcon;
  String? errorMessage;

  Future<void> searchWeather() async {
    if (isLoading || !formKey.currentState!.validate()) {
      return;
    }

    final city = cityController.text.trim();
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      errorMessage = null;
      weatherCity = null;
      temperature = null;
      weatherDescription = null;
      weatherIcon = null;
    });

    try {
      final weatherData = await weatherService.fetchWeather(city);
      final name = weatherData['name'] as String;
      final currentTemperature = (weatherData['main']['temp'] as num)
          .toDouble();
      final description = weatherData['weather'][0]['description'] as String;
      final icon = weatherData['weather'][0]['icon'] as String;

      // The screen may have closed while the request was running.
      if (!mounted) return;

      setState(() {
        weatherCity = name;
        temperature = currentTemperature;
        weatherDescription = description;
        weatherIcon = icon;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'Unable to read the weather data. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cityController,
                enabled: !isLoading,
                decoration: const InputDecoration(labelText: 'City'),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) => searchWeather(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a city name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: isLoading ? null : searchWeather,
                  child: const Text('Search'),
                ),
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                )
              else if (weatherCity != null)
                Column(
                  children: [
                    Text(
                      weatherCity!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Image.network(
                      'https://openweathermap.org/img/wn/$weatherIcon@2x.png',
                      width: 100,
                      height: 100,
                      semanticLabel: weatherDescription,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(child: Text('Image unavailable')),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${temperature!.toStringAsFixed(1)} °C',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(weatherDescription!),
                  ],
                )
              else
                const Text('Enter a city to view the weather.'),
            ],
          ),
        ),
      ),
    );
  }
}
