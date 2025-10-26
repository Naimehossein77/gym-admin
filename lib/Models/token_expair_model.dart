class TokenCleanupResponse {
  final bool success;
  final String message;
  final int expiredTokensRemoved;

  TokenCleanupResponse({
    required this.success,
    required this.message,
    required this.expiredTokensRemoved,
  });

  factory TokenCleanupResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?) ?? const {};
    return TokenCleanupResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      expiredTokensRemoved: (data['expired_tokens_removed'] ?? 0) as int,
    );
  }
}
