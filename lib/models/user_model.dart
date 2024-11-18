class UserModel {
  final String id;
  final String fullName;
  final String? profilePhotoPath;
  final String? bio;
  final int rating;
  final int followerCount;
  final int followingCount;
  final List<String> photos;

  UserModel({
    required this.id,
    required this.fullName,
    this.profilePhotoPath,
    this.bio,
    required this.rating,
    required this.followerCount,
    required this.followingCount,
    required this.photos,
  });

  // JSON'dan UserModel oluşturmak için bir fabrika yöntemi (mapleme)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      profilePhotoPath: json['profilePhotoPath'],
      bio: json['bio'],
      rating: json['rating'] ?? 0,
      followerCount: json['followerCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      photos: List<String>.from(json['photos'] ?? []),
    );
  }

  // JSON'a dönüştürmek için bir metot (eğer ihtiyacınız olursa)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profilePhotoPath': profilePhotoPath,
      'bio': bio,
      'rating': rating,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'photos': photos,
    };
  }
}
