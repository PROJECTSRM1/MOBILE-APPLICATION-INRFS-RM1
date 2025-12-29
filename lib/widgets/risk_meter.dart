import 'package:flutter/material.dart';

class RiskMeter extends StatelessWidget {
  final String rating;

  const RiskMeter({super.key, required this.rating});

  double get _riskValue {
    if (rating.contains("AAA")) return 0.2;
    if (rating.contains("AA")) return 0.4;
    if (rating.contains("A")) return 0.6;
    return 0.8;
  }

  String get _riskText {
    if (_riskValue <= 0.3) return "Low Risk";
    if (_riskValue <= 0.6) return "Moderate Risk";
    return "High Risk";
  }

  Color get _riskColor {
    if (_riskValue <= 0.3) return Colors.green;
    if (_riskValue <= 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Risk Meter",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: _riskValue,
          color: _riskColor,
          backgroundColor: Colors.grey.shade300,
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        Text(
          _riskText,
          style: TextStyle(color: _riskColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
