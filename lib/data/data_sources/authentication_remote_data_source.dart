import '../core/api_client.dart';
import '../models/request_token_model.dart';
import 'package:flutter/foundation.dart';

abstract class AuthenticationRemoteDataSource {
  Future<RequestTokenModel> getRequestToken();
  Future<RequestTokenModel> validateWithLogin(Map<String, dynamic> requestBody);
  Future<String?> createSession(Map<String, dynamic> requestBody);
  Future<bool> deleteSession(String sessionId);
}

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  final ApiClient _client;

  AuthenticationRemoteDataSourceImpl(this._client);

  @override
  Future<RequestTokenModel> getRequestToken() async {
    final response = await _client.get('authentication/token/new');
    debugPrint(response);
    final requestTokenModel = RequestTokenModel.fromJson(response);
    return requestTokenModel;
  }

  @override
  Future<RequestTokenModel> validateWithLogin(
      Map<String, dynamic> requestBody) async {
    final response = await _client.post(
      'authentication/token/validate_with_login',
      params: requestBody,
    );
    debugPrint(response);
    return RequestTokenModel.fromJson(response);
  }

  @override
  Future<String?> createSession(Map<String, dynamic> requestBody) async {
    final response = await _client.post(
      'authentication/session/new',
      params: requestBody,
    );
    debugPrint(response);
    return response['success'] ? response['session_id'] : null;
  }

  @override
  Future<bool> deleteSession(String sessionId) async {
    final response = await _client.deleteWithBody(
      'authentication/session',
      params: {
        'session_id': sessionId,
      },
    );
    return response['success'] ?? false;
  }
}
