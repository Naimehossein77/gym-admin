// models/member.dart
class MemberCreateRequest {
  final String name;
  final String email;
  final String phone;
  final String membershipType;

  MemberCreateRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.membershipType,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "membership_type": membershipType,
      };
}

class Member {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String membershipType;
  final String status;
  final String createdAt;
  final String updatedAt;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.membershipType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Member.fromJson(Map<String, dynamic> j) => Member(
        id: j["id"] as int,
        name: j["name"] as String,
        email: j["email"] as String,
        phone: j["phone"] as String,
        membershipType: j["membership_type"] as String,
        status: j["status"] as String,
        createdAt: j["created_at"] as String,
        updatedAt: j["updated_at"] as String,
      );
}
