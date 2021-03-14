class LogoutRequestParams {
  final String sessionId;

  LogoutRequestParams(this.sessionId);

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
      };
}
