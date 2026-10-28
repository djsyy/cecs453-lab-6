import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final apiKey = dotenv.env['API_KEY'];

    if (apiKey == null ||
        apiKey.trim().isEmpty ||
        apiKey.trim() == 'your_api_key_here') {
      throw Exception('Please configure your OpenWeatherMap API key in .env.');
    }

    final cityName = city.trim();
    if (cityName.isEmpty) {
      throw Exception('Please enter a city name.');
    }

    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather')
        .replace(
          queryParameters: {
            'q': cityName,
            'appid': apiKey.trim(),
            'units': 'metric',
          },
        );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Convert the JSON response text into a Dart map.
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please check the city name.');
      } else if (response.statusCode == 401) {
        throw Exception(
          'API key was not accepted. Please check your .env file.',
        );
      } else {
        throw Exception('Failed to load weather data. Please try again.');
      }
    } on http.ClientException {
      // Avoid displaying the request URL, which contains the API key.
      throw Exception(
        'Unable to connect. Please check your internet connection.',
      );
    } on FormatException {
      throw Exception('Unable to read the weather data. Please try again.');
    }
  }
}
