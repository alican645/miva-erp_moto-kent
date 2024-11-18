class PostModel {
  int? id;
  int? userId;
  String? userPhoto;
  String? userData;
  String? postContentTitle;
  String? postContent;
  String? postDate;
  String? postLocation;
  int? postCategory;

  PostModel(
      {this.id,
        this.userId,
        this.userPhoto,
        this.userData,
        this.postContentTitle,
        this.postContent,
        this.postDate,
        this.postLocation,
        this.postCategory});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userPhoto = json['user_photo'];
    userData = json['user_data'];
    postContentTitle = json['post_content_title'];
    postContent = json['post_content'];
    postDate = json['post_date'];
    postLocation = json['post_location'];
    postCategory = json['post_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_photo'] = this.userPhoto;
    data['user_data'] = this.userData;
    data['post_content_title'] = this.postContentTitle;
    data['post_content'] = this.postContent;
    data['post_date'] = this.postDate;
    data['post_location'] = this.postLocation;
    data['post_category'] = this.postCategory;
    return data;
  }
}