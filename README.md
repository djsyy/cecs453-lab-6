# CECS 453 - Lab 6: Weather App

A Flutter app that searches for a city and displays its current temperature in
degrees Celsius, weather description, and OpenWeatherMap weather image.

## Setup

1. Install Flutter with Dart 3.13.1 or a compatible later Dart 3 version.
2. Run `flutter pub get` from this directory.
3. Copy `.env.example` to `.env` if `.env` does not already exist.
4. Replace `your_api_key_here` in `.env` with your existing OpenWeatherMap API key.
5. Run `flutter run` and select an available device.

The `.env` file is a registered Flutter asset and is ignored by Git. Never commit
your real API key. Assets are included in distributed builds, so `.env` does not
make the key secret inside a built application. Restart the app after changing it.

## Code

- `lib/main.dart`: city form, loading and error states, and weather results.
- `lib/weather_service.dart`: HTTP requests and JSON decoding.

## Checks

```sh
flutter analyze
flutter test
```

Automated tests use fake responses and require no real API key. To check the live
app, search for a valid city, search for another city to check updated results and
images, try an unknown city, and try an empty input. Also check the error shown
when the device has no network connection.
