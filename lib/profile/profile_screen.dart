// lib/profile/profile_screen.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../models/user_model.dart';
import 'account_details_screen.dart';
import 'bank_details_screen.dart';
import 'customer_support_screen.dart';
import 'about_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  final String? token;

  const ProfileScreen({
    super.key,
    this.user,
    this.token,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileService _profileService;
  UserModel? _userProfile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final token = widget.token ?? AuthService.accessToken;

    if (token != null) {
      _profileService = ProfileService(
        authToken: token,
        invRegId: widget.user?.invRegId,
      );
      _userProfile = widget.user;
      
      // Fetch fresh user data if we have inv_reg_id
      if (widget.user?.invRegId != null) {
        _refreshUserProfile();
      }
    }
  }

  Future<void> _refreshUserProfile() async {
    if (widget.user?.invRegId == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedProfile = await _profileService.getUserProfile(
        invRegId: widget.user!.invRegId!,
      );

      if (mounted) {
        setState(() {
          _userProfile = updatedProfile;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error refreshing profile: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _profileService.logout();
      AuthService.logout();

      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    }
  }

  void _navigateToAccountDetails() async {
    final token = widget.token ?? AuthService.accessToken;
    if (token == null || _userProfile == null || _userProfile!.invRegId == null) {
      _showSnack('Unable to load account details');
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountDetailsScreen(
          token: token,
          invRegId: _userProfile!.invRegId!,
          userProfile: _userProfile!,
        ),
      ),
    );

    if (result == true && mounted) {
      // Refresh profile after update
      _refreshUserProfile();
    }
  }

  void _navigateToBankDetails() {
    final token = widget.token ?? AuthService.accessToken;
    if (token == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BankDetailsScreen(
          token: token,
        ),
      ),
    );
  }

  void _navigateToCustomerSupport() {
    final token = widget.token ?? AuthService.accessToken;
    if (token == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerSupportScreen(token: token),
      ),
    );
  }

  void _navigateToAboutUs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AboutUsScreen(),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFB87A3D)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFB87A3D),
                    child: Text(
                      _userProfile?.initials ?? 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userProfile?.fullName ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userProfile?.email ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu Items
            _buildMenuTile(
              icon: Icons.person_outline,
              title: 'Account details',
              onTap: _navigateToAccountDetails,
            ),
            _buildMenuTile(
              icon: Icons.account_balance,
              title: 'Bank & AutoPay',
              onTap: _navigateToBankDetails,
            ),
            _buildMenuTile(
              icon: Icons.support_agent,
              title: 'Customer support 24×7',
              onTap: _navigateToCustomerSupport,
            ),
            _buildMenuTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms & Conditions coming soon'),
                  ),
                );
              },
            ),
            _buildMenuTile(
              icon: Icons.info_outline,
              title: 'About us',
              onTap: _navigateToAboutUs,
            ),
            const SizedBox(height: 16),
            _buildMenuTile(
              icon: Icons.logout,
              title: 'Logout',
              textColor: Colors.red,
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? const Color(0xFFB87A3D)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}