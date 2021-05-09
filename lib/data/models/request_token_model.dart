class RequestTokenModel {
  final bool success;
  late final String? requestToken;
  late final String? expiresAt;

  RequestTokenModel({
    this.success = false,
    this.requestToken,
    this.expiresAt,
  });

  factory RequestTokenModel.fromJson(Map<String, dynamic> json) {
    return RequestTokenModel(
      success: json['success'],
      requestToken: json['request_token'],
      expiresAt: json['expires_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'request_token': requestToken,
      };
}
