import 'package:flutter/material.dart';
import '../../models/bond_model.dart';
import '../../widgets/risk_meter.dart';
import '../../widgets/yield_chart.dart';
import '../../widgets/pdf_button.dart';
import '../../widgets/series_bottom_sheet.dart';

class BondDetailsScreen extends StatefulWidget {
  final BondModel bond;

  const BondDetailsScreen({super.key, required this.bond});

  @override
  State<BondDetailsScreen> createState() => _BondDetailsScreenState();
}

class _BondDetailsScreenState extends State<BondDetailsScreen> {
  bool showPros = true;
  bool showProsConsSection = true;
  bool showAboutSection = false;

  /// ✅ FIX: define selectedSeries
  int selectedSeries = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.bond.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section("Bond Overview", [
            _row("Issuer", widget.bond.issuer),
            _row("CRISIL Rating", widget.bond.rating),
            _row("Interest", "${widget.bond.interest}%"),
            _row("Tenure", "${widget.bond.tenure} years"),
            _row("IPO Date", widget.bond.ipoDate),
          ]),

          _section("Risk Analysis", [
            RiskMeter(rating: widget.bond.rating),
          ]),

          _cardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerWithArrow(
                  title: "Pros and Cons",
                  expanded: showProsConsSection,
                  onTap: () => setState(() => showProsConsSection = !showProsConsSection),
                ),
                if (showProsConsSection) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _toggleButton("Pros", showPros, () => setState(() => showPros = true)),
                      const SizedBox(width: 12),
                      _toggleButton("Cons", !showPros, () => setState(() => showPros = false)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...(showPros ? widget.bond.pros : widget.bond.cons)
                      .map((e) => _bullet(e, showPros ? Colors.green : Colors.red)),
                ],
              ],
            ),
          ),

          _cardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerWithArrow(
                  title: "About",
                  expanded: showAboutSection,
                  onTap: () => setState(() => showAboutSection = !showAboutSection),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.bond.about,
                  maxLines: showAboutSection ? null : 1,
                  overflow: showAboutSection ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if (!showAboutSection)
                  GestureDetector(
                    onTap: () => setState(() => showAboutSection = true),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text("More",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ),

          _section("Yield Forecast", [
            YieldChart(interest: widget.bond.interest),
          ]),

          _section("Documents", [
            PdfButton(pdfUrl: "https://www.example.com/bond_prospectus.pdf"),
          ]),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              showSeriesBottomSheet(
                context: context,
                selectedSeries: selectedSeries,
                onSelected: (value) {
                  setState(() => selectedSeries = value);
                },
              );
            },
            child: const Text("Invest Now"),
          ),
        ],
      ),
    );
  }

  Widget _cardContainer({required Widget child}) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10)],
        ),
        child: child,
      );

  Widget _section(String title, List<Widget> children) => _cardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      );

  Widget _headerWithArrow(
          {required String title, required bool expanded, required VoidCallback onTap}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            onPressed: onTap,
          ),
        ],
      );

  Widget _row(String title, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _bullet(String text, Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.thumb_up, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
          ],
        ),
      );

  Widget _toggleButton(String text, bool active, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(text,
                  style: TextStyle(color: active ? Colors.white : Colors.black)),
            ),
          ),
        ),
      );
}
