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

  int selectedSeries = 3;

  static const Color brandGreen = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.bond.name),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            context,
            "Bond Overview",
            [
              _row("Issuer", widget.bond.issuer),
              _row("CRISIL Rating", widget.bond.rating),
              _row("Interest", "${widget.bond.interest}%"),
              _row("Tenure", "${widget.bond.tenure} years"),
              _row("IPO Date", widget.bond.ipoDate),
            ],
          ),

          _section(
            context,
            "Risk Analysis",
            [
              RiskMeter(rating: widget.bond.rating),
            ],
          ),

          _card(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                  "Pros and Cons",
                  showProsConsSection,
                  () => setState(
                    () => showProsConsSection = !showProsConsSection,
                  ),
                ),
                if (showProsConsSection) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _toggleButton(
                        "Pros",
                        showPros,
                        () => setState(() => showPros = true),
                      ),
                      const SizedBox(width: 12),
                      _toggleButton(
                        "Cons",
                        !showPros,
                        () => setState(() => showPros = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...(showPros ? widget.bond.pros : widget.bond.cons)
                      .map(
                        (e) => _bullet(
                          e,
                          showPros ? brandGreen : Colors.red.shade400,
                        ),
                      ),
                ],
              ],
            ),
          ),

          _card(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                  "About",
                  showAboutSection,
                  () => setState(
                    () => showAboutSection = !showAboutSection,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.bond.about,
                  maxLines: showAboutSection ? null : 1,
                  overflow: showAboutSection
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                if (!showAboutSection)
                  GestureDetector(
                    onTap: () => setState(() => showAboutSection = true),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "More",
                        style: TextStyle(
                          color: brandGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          _section(
            context,
            "Yield Forecast",
            [
              YieldChart(interest: widget.bond.interest),
            ],
          ),

          _section(
            context,
            "Documents",
            [
              PdfButton(
                pdfUrl: "https://www.example.com/bond_prospectus.pdf",
              ),
            ],
          ),

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

  // ---------- UI HELPERS ----------

  Widget _card(BuildContext context, Widget child) {
    final cardTheme = Theme.of(context).cardTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardTheme.shadowColor != null
            ? [
                BoxShadow(
                  color: cardTheme.shadowColor!,
                  blurRadius: 10,
                )
              ]
            : null,
      ),
      child: child,
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return _card(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _header(String title, bool expanded, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          icon: Icon(
            expanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
          ),
          onPressed: onTap,
        ),
      ],
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text, Color color) {
    return Padding(
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
  }

  Widget _toggleButton(
    String text,
    bool active,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? brandGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: brandGreen),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : brandGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
