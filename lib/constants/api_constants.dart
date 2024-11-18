class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080';
  //static const String baseUrl = 'http://192.168.2.78:8080';


  static const String registerEndpoint = '$baseUrl/api/Auth/Register';
  static const String loginEndpoint = '$baseUrl/api/Auth/Login';
  static const String refreshTokenEndpoint = '$baseUrl/api/Auth/RefreshToken';
  static const String revokeEndpoint = '$baseUrl/api/Auth/Revoke';
  static const String revokeAllEndpoint = '$baseUrl/api/Auth/RevokeAll';


  static const String userProfileEndpoint = '$baseUrl/api/UserProfile/GetProfile';
  static const String updateProfileEndpoint = '$baseUrl/api/UserProfile/UpdateProfile';


  static const String getUserPhotosEndpoint = '$baseUrl/api/Photo/GetUserPhotos';
  static const String uploadPhotoEndpoint = '$baseUrl/api/Photo/UploadPhoto';
}
