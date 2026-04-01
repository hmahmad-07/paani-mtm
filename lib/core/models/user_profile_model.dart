import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(jsonDecode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  bool success;
  Data data;

  UserProfileModel({required this.success, required this.data});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
}

class Data {
  User user;

  Data({required this.user});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"user": user.toJson()};
}

class User {
  int id;
  String name;
  String email;
  String phoneNumber;
  String address;
  dynamic profileImage;
  String status;
  String rating;
  bool isRider;
  bool isApprovedRider;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.profileImage,
    required this.status,
    required this.rating,
    required this.isRider,
    required this.isApprovedRider,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    address: json["address"],
    profileImage: json["profile_image"],
    status: json["status"],
    rating: json["rating"],
    isRider: json["is_rider"],
    isApprovedRider: json["is_approved_rider"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone_number": phoneNumber,
    "address": address,
    "profile_image": profileImage,
    "status": status,
    "rating": rating,
    "is_rider": isRider,
    "is_approved_rider": isApprovedRider,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
