import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_kent/services/api_service.dart'; // API servisi import edildi.
import 'package:moto_kent/constants/api_constants.dart'; // API endpointleri import edildi.
import 'dart:convert'; // JSON çözümlemek için import edildi.
import 'package:http/http.dart' as http; // Multipart request için

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _userModel;
  final Color _editProfileButtonBackground = const Color(0xfff48a34);
  final imagePicker = ImagePicker();
  List<String> _userPhotos = [];

  File? _selectedProfilePhoto;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      await fetchUserProfile(userId);
      await fetchUserPhotos(userId);
    } else {
      Fluttertoast.showToast(msg: 'Kullanıcı ID bulunamadı');
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    try {
      final response = await ApiService().makeAuthenticatedRequest(
        '${ApiConstants.userProfileEndpoint}/$userId',
        'GET',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _userModel = UserModel.fromJson(data);
        });
      } else {
        Fluttertoast.showToast(msg: 'Kullanıcı profili yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata: $e');
    }
  }

  Future<void> fetchUserPhotos(String userId) async {
    try {
      final response = await ApiService().makeAuthenticatedRequest(
        '${ApiConstants.getUserPhotosEndpoint}?userId=$userId',
        'GET',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body); // Gelen yanıt bir liste olarak çözümlenir
        setState(() {
          _userPhotos = List<String>.from(data); // JSON listesini doğrudan atıyoruz
        });
      } else {
        Fluttertoast.showToast(msg: 'Kullanıcı fotoğrafları yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata: $e');
    }
  }



  Future<void> _selectAndUploadPhoto() async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      await _uploadUserPhoto(pickedImage);
    }
  }

  Future<void> _uploadUserPhoto(XFile photo) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId == null) {
        Fluttertoast.showToast(msg: 'Oturum açılmadı');
        return;
      }

      var fields = {'userId': userId};
      var decodedData = await ApiService().makeMultipartRequest(
        ApiConstants.uploadPhotoEndpoint,
        photo,
        fields,
      );

      // Fotoğraf URL'sini listeye ekleyin
      String photoUrl = decodedData['photoUrl']; // Backend'den dönen tam URL
      setState(() {
        _userPhotos.add(photoUrl);
      });
      Fluttertoast.showToast(msg: 'Fotoğraf yüklendi');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata: $e');
    }
  }


  // Kullanıcı profilini güncelleme fonksiyonu
  Future<void> _updateUserProfile(String userId, String fullName, String bio, File? profilePhotoFile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'Oturum açılmadı');
        return;
      }

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiConstants.updateProfileEndpoint),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['userId'] = userId;
      request.fields['fullName'] = fullName;
      request.fields['bio'] = bio;

      if (profilePhotoFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profilePicture',
          profilePhotoFile.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Profil güncellendi');
        await fetchUserProfile(userId); // Profil güncellendikten sonra yeniden yükle
      } else {
        Fluttertoast.showToast(msg: 'Profil güncellenemedi: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (_userModel == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUserProfile, // Sayfayı yenilemek için çağrılacak fonksiyon
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Scroll işlemi her durumda etkin
        child: Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profil Fotoğrafı ve Kullanıcı Bilgileri
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _userModel!.profilePhotoPath != null &&
                        _userModel!.profilePhotoPath!.isNotEmpty
                        ? NetworkImage('${ApiConstants.baseUrl}${_userModel!.profilePhotoPath!}')
                        : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                  ),
                  SizedBox(
                    width: width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              _userModel!.followerCount.toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text('Takipçi'),
                          ],
                        ),
                        SizedBox(width: width * 0.05),
                        Column(
                          children: [
                            Text(
                              _userModel!.followingCount.toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text('Takip'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: width * 0.2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          _showEditProfileModal(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Kullanıcı Bilgileri
              Row(
                children: [
                  Text(
                    _userModel!.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_userModel!.bio ?? 'Biyografi henüz eklenmedi'),
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              // Fotoğraf Galerisi Kısmı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: _userPhotos.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: _selectAndUploadPhoto,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 40, color: Colors.black),
                          ),
                        ),
                      );
                    } else {
                      return Image.network(
                        '${ApiConstants.baseUrl}${_userPhotos[index - 1]}',
                        fit: BoxFit.cover,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showEditProfileModal(BuildContext context) {
    TextEditingController fullNameController = TextEditingController(text: _userModel?.fullName);
    TextEditingController bioController = TextEditingController(text: _userModel?.bio);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Profili Düzenle",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: "Ad Soyad"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: "Biyografi"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _selectedProfilePhoto = File(pickedImage.path);
                    });
                  }
                },
                child: const Text("Profil Fotoğrafı Seç"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? userId = prefs.getString('user_id');

                  if (userId != null) {
                    await _updateUserProfile(
                      userId,
                      fullNameController.text,
                      bioController.text,
                      _selectedProfilePhoto,
                    );
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(msg: 'Kullanıcı ID bulunamadı');
                  }
                },
                child: const Text("Kaydet"),
              ),
            ],
          ),
        );
      },
    );
  }
}
