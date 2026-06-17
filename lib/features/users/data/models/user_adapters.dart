part of 'user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User(
      id: reader.readInt(),
      name: reader.readString(),
      username: reader.readString(),
      email: reader.readString(),
      phone: reader.readString(),
      website: reader.readString(),
      address: reader.read() as UserAddress,
      company: reader.read() as UserCompany,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeInt(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.username)
      ..writeString(obj.email)
      ..writeString(obj.phone)
      ..writeString(obj.website)
      ..write(obj.address)
      ..write(obj.company);
  }
}

class UserAddressAdapter extends TypeAdapter<UserAddress> {
  @override
  final int typeId = 1;

  @override
  UserAddress read(BinaryReader reader) {
    return UserAddress(
      street: reader.readString(),
      suite: reader.readString(),
      city: reader.readString(),
      zipcode: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserAddress obj) {
    writer
      ..writeString(obj.street)
      ..writeString(obj.suite)
      ..writeString(obj.city)
      ..writeString(obj.zipcode);
  }
}

class UserCompanyAdapter extends TypeAdapter<UserCompany> {
  @override
  final int typeId = 2;

  @override
  UserCompany read(BinaryReader reader) {
    return UserCompany(
      name: reader.readString(),
      catchPhrase: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserCompany obj) {
    writer
      ..writeString(obj.name)
      ..writeString(obj.catchPhrase);
  }
}
