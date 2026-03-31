class User {
  const User({
    required this.email,
    required this.name,
  });

  final String email;
  final String name;

  User copyWith({
    String? email,
    String? name,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

