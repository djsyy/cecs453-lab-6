import 'package:flutter/material.dart';

void main() {
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

  void searchWeather() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // The weather service will be connected in a later step.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Weather search is not connected yet.')),
    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: cityController,
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
              ElevatedButton(
                onPressed: searchWeather,
                child: const Text('Search'),
              ),
              const SizedBox(height: 24),
              const Text('Enter a city to view the weather.'),
            ],
          ),
        ),
      ),
    );
  }
}
