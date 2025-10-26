class MemberTokenResponse {
  final String token;
  final int memberId;
  final String createdAt;
  final String expiresAt;
  final String? encryptedPayload;

  MemberTokenResponse({
    required this.token,
    required this.memberId,
    required this.createdAt,
    required this.expiresAt,
    this.encryptedPayload,
  });

  factory MemberTokenResponse.fromJson(Map<String, dynamic> j) {
    return MemberTokenResponse(
      token: (j['token'] ?? '').toString(),
      memberId: j['member_id'] is int
          ? j['member_id'] as int
          : int.tryParse('${j['member_id']}') ?? 0,
      createdAt: (j['created_at'] ?? '').toString(),
      expiresAt: (j['expires_at'] ?? '').toString(),
      encryptedPayload: j['encrypted_payload']?.toString(),
    );
  }
}
