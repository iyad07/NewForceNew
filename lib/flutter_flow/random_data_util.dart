import 'dart:math';

/// Utility class for generating random data
class RandomDataUtil {
  static final Random _random = Random();

  /// Generate a random integer between min and max (inclusive)
  static int randomInteger(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Generate a random double between min and max
  static double randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Generate a random boolean
  static bool randomBool() {
    return _random.nextBool();
  }

  /// Generate a random string of specified length
  static String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }
}

// Global functions for backward compatibility
int randomInteger(int min, int max) => RandomDataUtil.randomInteger(min, max);
double randomDouble(double min, double max) => RandomDataUtil.randomDouble(min, max);
bool randomBool() => RandomDataUtil.randomBool();
String randomString(int length) => RandomDataUtil.randomString(length);