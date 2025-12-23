import 'dart:math';

class InvestorIdGenerator {
  static String generate() {
    final random = Random();
    final number = random.nextInt(9000) + 1000; // 1000–9999
    return 'I$number';
  }
}
