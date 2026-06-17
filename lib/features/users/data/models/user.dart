import 'package:hive/hive.dart';

part 'user_adapters.dart';

// ---------- Address ----------

class UserAddress {
  const UserAddress({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        street: json['street'] as String,
        suite: json['suite'] as String,
        city: json['city'] as String,
        zipcode: json['zipcode'] as String,
      );

  final String street;
  final String suite;
  final String city;
  final String zipcode;
}

// ---------- Company ----------

class UserCompany {
  const UserCompany({required this.name, required this.catchPhrase});

  factory UserCompany.fromJson(Map<String, dynamic> json) => UserCompany(
        name: json['name'] as String,
        catchPhrase: json['catchPhrase'] as String,
      );

  final String name;
  final String catchPhrase;
}

// ---------- User ----------

class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        website: json['website'] as String,
        address: UserAddress.fromJson(
          json['address'] as Map<String, dynamic>,
        ),
        company: UserCompany.fromJson(
          json['company'] as Map<String, dynamic>,
        ),
      );

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final UserAddress address;
  final UserCompany company;
}
