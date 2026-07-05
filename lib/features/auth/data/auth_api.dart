import '../../../core/network/api_client.dart';

class AuthApi {
  Future<LoginResponse> login({
    required String identifier,
    required String password,
  }) async {
    final response = await ApiClient.dio.post(
      '/auth/login',
      data: {
        'identifier': identifier,
        'password': password,
      },
    );

    final data = response.data['data'];

    if (data == null) {
      throw Exception('login data가 없습니다.');
    }

    final loginResponse = LoginResponse.fromJson(
      Map<String, dynamic>.from(data),
    );

    ApiClient.setToken(loginResponse.accessToken);

    return loginResponse;
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String expiresIn;
  final User user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? '',
      user: User.fromJson(
        Map<String, dynamic>.from(json['user'] ?? {}),
      ),
    );
  }
}

class User {
  final String id;
  final String name;
  final String role;
  final bool consentRequired;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.consentRequired,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      consentRequired: json['consentRequired'] ?? false,
    );
  }
}