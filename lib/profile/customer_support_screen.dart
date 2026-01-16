// lib/profile/customer_support_screen.dart

import 'package:flutter/material.dart';
// import '../services/profile_service.dart';

class CustomerSupportScreen extends StatefulWidget {
  final String token;

  const CustomerSupportScreen({
    super.key,
    required this.token,
  });

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  // Ticket functionality commented out - not implemented yet
  // late ProfileService _profileService;
  // List<dynamic> _tickets = [];
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _profileService = ProfileService(authToken: widget.token);
    // _loadTickets();
  }

  // Future<void> _loadTickets() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     final tickets = await _profileService.getSupportTickets();
  //     if (mounted) {
  //       setState(() {
  //         _tickets = tickets;
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error loading tickets: $e');
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  // Future<void> _createTicket() async {
  //   final result = await showDialog<Map<String, String>>(
  //     context: context,
  //     builder: (context) => const CreateTicketDialog(),
  //   );
  //
  //   if (result != null) {
  //     try {
  //       await _profileService.createSupportTicket(
  //         subject: result['subject']!,
  //         description: result['description']!,
  //         category: result['category']!,
  //       );
  //
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Support ticket created successfully'),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //         _loadTickets();
  //       }
  //     } catch (e) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Failed to create ticket: $e'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Customer Support',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Contact Information Section
            _buildContactCard(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '24×7 Support Available',
              contactValue: '+91-1800-123-4567',
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Call feature would launch phone dialer'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'Response within 24 hours',
              contactValue: 'support@inrfs.com',
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email feature would launch email client'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.chat_bubble_outline,
              title: 'Live Chat',
              subtitle: 'Available 9 AM - 9 PM',
              contactValue: 'Start Chat',
              color: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat feature coming soon'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // FAQs Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFAQItem(
                    'How do I add money to my account?',
                    'Go to Dashboard > Add Money and follow the instructions to deposit funds into your account.',
                  ),
                  _buildFAQItem(
                    'How long does verification take?',
                    'Account verification usually takes 24-48 hours after you submit all required documents.',
                  ),
                  _buildFAQItem(
                    'How do I withdraw my money?',
                    'Go to Profile > Bank Details and ensure your bank account is verified, then initiate a withdrawal from the Dashboard.',
                  ),
                  _buildFAQItem(
                    'What documents are required for KYC?',
                    'You need to provide a valid ID proof (Aadhar/PAN), address proof, and a recent photograph.',
                  ),
                  _buildFAQItem(
                    'How can I track my investments?',
                    'All your investments can be tracked from the Dashboard. You can view detailed information by tapping on each investment.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Help Center Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need More Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Our customer support team is available 24×7 to assist you with any queries or issues.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Available 24×7',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'English & Hindi Support',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String contactValue,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contactValue,
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Text(
          answer,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Ticket creation dialog - commented out for future implementation
// class CreateTicketDialog extends StatefulWidget {
//   const CreateTicketDialog({super.key});
//
//   @override
//   State<CreateTicketDialog> createState() => _CreateTicketDialogState();
// }
//
// class _CreateTicketDialogState extends State<CreateTicketDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _subjectController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String _selectedCategory = 'general';
//
//   final List<Map<String, String>> _categories = [
//     {'value': 'general', 'label': 'General Inquiry'},
//     {'value': 'payment', 'label': 'Payment Issue'},
//     {'value': 'withdrawal', 'label': 'Withdrawal Issue'},
//     {'value': 'account', 'label': 'Account Related'},
//     {'value': 'technical', 'label': 'Technical Problem'},
//   ];
//
//   @override
//   void dispose() {
//     _subjectController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Create Support Ticket'),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 decoration: const InputDecoration(
//                   labelText: 'Category',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: _categories.map((category) {
//                   return DropdownMenuItem(
//                     value: category['value'],
//                     child: Text(category['label']!),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   setState(() => _selectedCategory = newValue!);
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _subjectController,
//                 decoration: const InputDecoration(
//                   labelText: 'Subject',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (val) {
//                   if (val == null || val.isEmpty) {
//                     return 'Please enter a subject';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 5,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(),
//                   alignLabelWithHint: true,
//                 ),
//                 validator: (val) {
//                   if (val == null || val.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               Navigator.pop(context, {
//                 'category': _selectedCategory,
//                 'subject': _subjectController.text,
//                 'description': _descriptionController.text,
//               });
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFB87A3D),
//           ),
//           child: const Text('Submit', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }