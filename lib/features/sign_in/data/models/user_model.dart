class User {
  final int userId;
  final String username;
  final String firstName;
  final String secondName;
  final String lastName;
  final bool gender;
  final String email;
  final String notes;
  final int userPoints;

  User(
      {required this.userId,
      required this.username,
      required this.firstName,
      required this.secondName,
      required this.lastName,
      required this.gender,
      required this.email,
      required this.notes,
      required this.userPoints});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        username: json['username'] ?? '',
        firstName: json['firstName'] ?? '',
        secondName: json['secondName'] ?? '',
        lastName: json['lastName'] ?? '',
        gender: json['gender'] ?? false,
        email: json['email'] ?? 'غير متوفر',
        notes: json['notes'] ?? 'لا يوجد ملاحظات',
        userPoints: json['userPoints'] ?? 0);
  }
}

class Tokens {
  final String refreshToken;
  final String accessToken;

  Tokens({
    required this.refreshToken,
    required this.accessToken,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      refreshToken: json['refreshToken'],
      accessToken: json['accessToken'],
    );
  }
}

class AuthResponse {
  final User user;
  final Tokens tokens;

  AuthResponse({
    required this.user,
    required this.tokens,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
        user: User.fromJson(json['user']),
        tokens: Tokens.fromJson(json['tokens']));
  }
}
