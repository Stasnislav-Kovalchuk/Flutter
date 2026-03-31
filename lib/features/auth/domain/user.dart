class User {
  const User({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  User copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

