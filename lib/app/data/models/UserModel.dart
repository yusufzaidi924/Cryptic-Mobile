class UserModel {
  int id;
  String username;
  String password;
  String phone;
  String? lastName;
  String? firstName;
  String? street;
  String? city;
  String? state;
  int? zipcode;
  DateTime? birthday;
  String? licenseState;
  String? email;
  String? licenseNumber;
  String? frontID;
  String? backID;
  String? selfie;
  DateTime? createdAt;
  DateTime? updatedAt;
  int otp;
  int status = 0;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.phone,
    this.lastName,
    this.firstName,
    this.street,
    this.city,
    this.state,
    this.zipcode,
    this.birthday,
    this.licenseState,
    this.email,
    this.licenseNumber,
    this.frontID,
    this.backID,
    this.selfie,
    this.createdAt,
    this.updatedAt,
    required this.otp,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      lastName: json['last_name'] ?? 'User' as String?,
      firstName: json['first_name'] ?? 'Criptacy' as String?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipcode: json['zipcode'] as int?,
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'] as String)
          : null,
      licenseState: json['licenseState'] as String?,
      email: json['email'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      frontID: json['frontID'] as String?,
      backID: json['backID'] as String?,
      selfie: json['selfie'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      otp: json['otp'] as int,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['last_name'] = this.lastName;
    data['first_name'] = this.firstName;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['birthday'] = this.birthday?.toIso8601String();
    data['licenseState'] = this.licenseState;
    data['email'] = this.email;
    data['licenseNumber'] = this.licenseNumber;
    data['frontID'] = this.frontID;
    data['backID'] = this.backID;
    data['selfie'] = this.selfie;
    data['created_at'] = this.createdAt?.toIso8601String();
    data['updated_at'] = this.updatedAt?.toIso8601String();
    data['otp'] = this.otp;
    return data;
  }
}
