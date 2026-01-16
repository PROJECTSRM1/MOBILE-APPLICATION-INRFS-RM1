// lib/profile/bank_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bank_model.dart';
import '../services/profile_service.dart';

class BankDetailsScreen extends StatefulWidget {
  final String token;

  const BankDetailsScreen({
    super.key,
    required this.token,
  });

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  late ProfileService _profileService;
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _confirmAccountController = TextEditingController();
  
  int _selectedBankId = 1;
  bool _isSaving = false;
  bool _showAccountNumber = false;
  bool _showAddForm = false;
  bool _isLoadingBanks = false;
  
  List<BankModel> _bankAccounts = [];

  final List<Map<String, dynamic>> _banks = [
    {'id': 1, 'name': 'HDFC Bank'},
    {'id': 2, 'name': 'ICICI Bank'},
    {'id': 3, 'name': 'State Bank of India'},
    {'id': 4, 'name': 'Axis Bank'},
    {'id': 5, 'name': 'Kotak Mahindra Bank'},
    {'id': 6, 'name': 'Punjab National Bank'},
    {'id': 7, 'name': 'Bank of Baroda'},
    {'id': 8, 'name': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService(authToken: widget.token);
    _loadAllBankDetails();
    
    print('🔑 Token in BankDetailsScreen: ${widget.token.substring(0, 20)}...');
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _ifscController.dispose();
    _confirmAccountController.dispose();
    super.dispose();
  }

  Future<void> _loadAllBankDetails() async {
    setState(() => _isLoadingBanks = true);

    try {
      // Try to get bank details
      final bank = await _profileService.getBankDetails();
      
      if (mounted) {
        setState(() {
          _bankAccounts = bank != null ? [bank] : [];
          _isLoadingBanks = false;
          
          // Show form if no banks exist
          if (_bankAccounts.isEmpty) {
            _showAddForm = true;
          }
        });
        
        print('✅ Loaded ${_bankAccounts.length} bank account(s)');
      }
    } catch (e) {
      print('❌ Error loading bank details: $e');
      if (mounted) {
        setState(() {
          _isLoadingBanks = false;
          _showAddForm = true; // Show form if error
        });
      }
    }
  }

  Future<void> _saveBankDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_accountNumberController.text != _confirmAccountController.text) {
      _showSnackBar(
        'Account numbers do not match',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final bank = BankModel(
        bankId: _selectedBankId,
        bankAccountNo: _accountNumberController.text.trim(),
        ifscCode: _ifscController.text.trim().toUpperCase(),
      );

      print('💾 Attempting to save bank details...');
      print('📤 Bank data: ${bank.toJson()}');

      final response = await _profileService.addBankDetails(bank);

      print('✅ Bank details saved successfully: $response');

      if (mounted) {
        _showSnackBar(
          'Bank details added successfully! Your account is being verified.',
          isError: false,
        );
        
        // Clear form
        _accountNumberController.clear();
        _ifscController.clear();
        _confirmAccountController.clear();
        setState(() {
          _selectedBankId = 1;
          _showAddForm = false;
        });
        
        // Reload bank details to show the new one
        await _loadAllBankDetails();
      }
    } catch (e) {
      print('❌ Error saving bank details: $e');
      
      if (mounted) {
        String errorMessage = e.toString();
        
        if (errorMessage.contains('Exception:')) {
          errorMessage = errorMessage.replaceAll('Exception:', '').trim();
        }
        
        if (errorMessage.contains('Unauthorized') || errorMessage.contains('401')) {
          errorMessage = 'Session expired. Please login again.';
        } else if (errorMessage.contains('already exists')) {
          errorMessage = 'This bank account already exists in the system.';
        } else if (errorMessage.contains('422')) {
          errorMessage = 'Invalid bank details. Please check and try again.';
        }
        
        _showSnackBar(errorMessage, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Bank & AutoPay',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoadingBanks
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB87A3D)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show all existing bank accounts
                  if (_bankAccounts.isNotEmpty) ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _bankAccounts.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildExistingBankView(_bankAccounts[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Add new bank button
                    if (!_showAddForm)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _showAddForm = true);
                          },
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Add Another Bank Account'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB87A3D),
                            side: const BorderSide(color: Color(0xFFB87A3D)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                  
                  // Show add form
                  if (_showAddForm) ...[
                    if (_bankAccounts.isNotEmpty) const SizedBox(height: 16),
                    _buildAddBankForm(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildExistingBankView(BankModel bank) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB87A3D).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFFB87A3D),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.bankName ?? 'Bank Account',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: bank.isVerified == true
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        bank.isVerified == true
                            ? 'Verified'
                            : 'Pending Verification',
                        style: TextStyle(
                          fontSize: 11,
                          color: bank.isVerified == true
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildInfoRow('Account Number', bank.maskedAccountNo),
          const SizedBox(height: 16),
          _buildInfoRow('IFSC Code', bank.ifscCode),
          if (bank.createdAt != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              'Added On',
              '${bank.createdAt!.day}/${bank.createdAt!.month}/${bank.createdAt!.year}',
            ),
          ],
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bank details are verified for security. Contact support to update.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddBankForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Bank Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_bankAccounts.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() => _showAddForm = false);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Bank Selection
                const Text(
                  'Select Bank',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: _selectedBankId,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.account_balance,
                      color: Color(0xFFB87A3D),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _banks.map((bank) {
                    return DropdownMenuItem<int>(
                      value: bank['id'],
                      child: Text(bank['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedBankId = value!);
                  },
                  validator: (value) {
                    if (value == null) return 'Please select a bank';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Account Number
                const Text(
                  'Account Number',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  obscureText: !_showAccountNumber,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFFB87A3D),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showAccountNumber
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _showAccountNumber = !_showAccountNumber);
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter account number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account number';
                    }
                    if (value.length < 9) {
                      return 'Account number must be at least 9 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Confirm Account Number
                const Text(
                  'Confirm Account Number',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmAccountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFFB87A3D),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Re-enter account number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm account number';
                    }
                    if (value != _accountNumberController.text) {
                      return 'Account numbers do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // IFSC Code
                const Text(
                  'IFSC Code',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ifscController,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.code,
                      color: Color(0xFFB87A3D),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'e.g., HDFC0001234',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter IFSC code';
                    }
                    if (value.length != 11) {
                      return 'IFSC code must be 11 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ensure the account details are correct. Once added, bank details cannot be modified without contacting support.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveBankDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87A3D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: const Color(0xFFB87A3D).withValues(alpha: 0.5),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Add Bank Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}