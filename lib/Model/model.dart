
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
}
