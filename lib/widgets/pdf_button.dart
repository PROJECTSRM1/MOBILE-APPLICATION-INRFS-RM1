import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfButton extends StatelessWidget {
  final String pdfUrl;

  const PdfButton({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final uri = Uri.parse(pdfUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text("View Prospectus"),
    );
  }
}
