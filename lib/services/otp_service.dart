class OTPService {
  static const String emailOtp = '123456';
  static const String mobileOtp = '654321';

  static bool verify({
    required String email,
    required String mobile,
  }) {
    return email == emailOtp && mobile == mobileOtp;
  }
}
