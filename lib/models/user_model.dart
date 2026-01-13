// class UserModel {
//   final String name;
//   final String email;
//   final String mobile;
//   final String customerId;

//   const UserModel({
//     required this.name,
//     required this.email,
//     required this.mobile,
//     required this.customerId,
//   });
// }









// lib/models/user_model.dart

class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String email;
  final String mobile;
  final String? customerId;
  final String? invRegId;
  final int? roleId;
  final int? genderId;
  final int? age;
  final String? dob;
  final bool? isEmailVerified;
  final bool? isMobileVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    required this.email,
    required this.mobile,
    this.customerId,
    this.invRegId,
    this.roleId,
    this.genderId,
    this.age,
    this.dob,
    this.isEmailVerified,
    this.isMobileVerified,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    if (firstName != null) {
      return firstName!;
    }
    return email.split('@').first;
  }

  String get displayFirstName {
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName!;
    }
    if (name != null && name!.isNotEmpty) {
      return name!.split(' ').first;
    }
    return email.split('@').first;
  }

  String get displayLastName {
    if (lastName != null && lastName!.isNotEmpty) {
      return lastName!;
    }
    if (name != null && name!.isNotEmpty) {
      final parts = name!.split(' ');
      if (parts.length > 1) {
        return parts.sublist(1).join(' ');
      }
    }
    return '';
  }

  String get displayName => fullName;

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    }
    if (name != null && name!.isNotEmpty) {
      final parts = name!.split(' ');
      if (parts.length > 1) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? json['inv_reg_id']?.toString(),
      invRegId: json['inv_reg_id']?.toString() ?? json['customer_id']?.toString(),
      roleId: json['role_id'],
      genderId: json['gender_id'],
      age: json['age'],
      dob: json['dob']?.toString(),
      isEmailVerified: json['is_email_verified'],
      isMobileVerified: json['is_mobile_verified'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (name != null) 'name': name,
      'email': email,
      'mobile': mobile,
      if (customerId != null) 'customer_id': customerId,
      if (invRegId != null) 'inv_reg_id': invRegId,
      if (roleId != null) 'role_id': roleId,
      if (genderId != null) 'gender_id': genderId,
      if (age != null) 'age': age,
      if (dob != null) 'dob': dob,
      if (isEmailVerified != null) 'is_email_verified': isEmailVerified,
      if (isMobileVerified != null) 'is_mobile_verified': isMobileVerified,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? mobile,
    String? customerId,
    String? invRegId,
    int? roleId,
    int? genderId,
    int? age,
    String? dob,
    bool? isEmailVerified,
    bool? isMobileVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      customerId: customerId ?? this.customerId,
      invRegId: invRegId ?? this.invRegId,
      roleId: roleId ?? this.roleId,
      genderId: genderId ?? this.genderId,
      age: age ?? this.age,
      dob: dob ?? this.dob,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isMobileVerified: isMobileVerified ?? this.isMobileVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $fullName, email: $email, invRegId: $invRegId)';
  }
}