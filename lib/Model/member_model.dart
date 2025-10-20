class MemberModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String membershipType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.membershipType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      membershipType: json['membership_type'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'membership_type': membershipType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
