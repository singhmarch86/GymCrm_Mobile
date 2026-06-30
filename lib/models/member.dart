class Member {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String status;

  final String? email;
  final String? gender;
  final String? address;

  final String? startDate;
  final String? expiryDate;
  final int? membershipPlanId;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.status,
    required this.membershipPlanId,
    this.email,
    this.gender,
    this.address,
    this.startDate,
    this.expiryDate,
  });

  factory Member.fromJson(
      Map<String, dynamic> json,
      ) {
    return Member(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',

      email: json['email'],
      gender: json['gender'],
      address: json['address'],

      startDate: json['start_date'],
      expiryDate: json['expiry_date'],
      membershipPlanId: json['membership_plan_id'] as int?,
    );
  }
}