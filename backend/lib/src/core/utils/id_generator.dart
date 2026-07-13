import 'dart:math';

class IdGenerator {
  IdGenerator([Random? random]) : _random = random ?? Random.secure();

  final Random _random;

  String call(String prefix) {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final randomPart = _random
        .nextInt(0xFFFFFF)
        .toRadixString(36)
        .padLeft(5, '0');
    return '$prefix-$timestamp$randomPart';
  }
}
