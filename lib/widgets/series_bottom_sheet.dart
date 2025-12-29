import 'package:flutter/material.dart';
import '../models/bond_series_model.dart';

void showSeriesBottomSheet({
  required BuildContext context,
  required int selectedSeries,
  required ValueChanged<int> onSelected,
}) {
  const List<BondSeriesModel> seriesList = [
    BondSeriesModel(series: 3, interest: 13.00, tenure: 5, payout: "Monthly", highest: true),
    BondSeriesModel(series: 2, interest: 12.75, tenure: 4, payout: "Monthly"),
    BondSeriesModel(series: 1, interest: 12.50, tenure: 3, payout: "Monthly"),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                const Text(
                  "Series",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Sorted from highest to lowest interest",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                /// Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Interest (p.a)", style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("Tenure", style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("Payout", style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("Series", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 24),

                /// Series list (NO Radio widget – no deprecation)
                ...seriesList.map((s) {
                  final bool isSelected = selectedSeries == s.series;

                  return InkWell(
                    onTap: () {
                      setModalState(() => selectedSeries = s.series);
                      onSelected(s.series);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("${s.interest.toStringAsFixed(2)}%"),
                                    if (s.highest)
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          "Highest",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                  ],
                                ),
                                Text("${s.tenure}y"),
                                Text(s.payout),
                                Text("${s.series}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                /// Done button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Done"),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
