// lib/Models/member_with_token.dart
class MemberWithToken {
  final int memberId;
  final String username;
  final String token;
  final String tokenIssuedAt;   // 🆕
  final String tokenExpiresAt;  // 🆕

  MemberWithToken({
    required this.memberId,
    required this.username,
    required this.token,
    this.tokenIssuedAt = '',
    this.tokenExpiresAt = '',
  });

  factory MemberWithToken.fromJson(Map<String, dynamic> j) {
    return MemberWithToken(
      memberId: (j['member_id'] ?? 0) as int,
      username: (j['username'] ?? '').toString(),
      token: (j['token'] ?? '').toString(),
      tokenIssuedAt: (j['token_issued_at'] ?? '').toString(),   // 🆕
      tokenExpiresAt: (j['token_expires_at'] ?? '').toString(), // 🆕
    );
  }
}
