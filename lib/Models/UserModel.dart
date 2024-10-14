class UserModel {
  int? id;
  String? userName;
  String? userSurname;
  String? userBirthday;
  String? profilePhotoPath;
  List<String>? sharingPhotoPath;
  String? userContent;
  int? userRating;
  int? fallower;
  int? fallowed;

  UserModel(
      {this.id,
        this.userName,
        this.userSurname,
        this.userBirthday,
        this.profilePhotoPath,
        this.sharingPhotoPath,
        this.userContent,
        this.userRating,
        this.fallower,
        this.fallowed});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    userSurname = json['user_surname'];
    userBirthday = json['user_birthday'];
    profilePhotoPath = json['profile_photo_path'];
    sharingPhotoPath = json['sharing_photo_path'].cast<String>();
    userContent = json['user_content'];
    userRating = json['user_rating'];
    fallower = json['fallower'];
    fallowed = json['fallowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['user_surname'] = this.userSurname;
    data['user_birthday'] = this.userBirthday;
    data['profile_photo_path'] = this.profilePhotoPath;
    data['sharing_photo_path'] = this.sharingPhotoPath;
    data['user_content'] = this.userContent;
    data['user_rating'] = this.userRating;
    data['fallower'] = this.fallower;
    data['fallowed'] = this.fallowed;
    return data;
  }
}