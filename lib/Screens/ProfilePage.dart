import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/Models/UserModel.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //model değişkeni ve bu modele ait özellik değişkenleri
  UserModel? _userModel;
  String? _profilePhotoPath;
  String? _userName;
  String? _userSurname;
  String? _userBirthday;
  int? _userRating;
  List<String>? _userPhotos;
  int? _fallower;
  int? _fallowed;
  String? _userContent;

  //sayfada kullanılacak renkler
  Color _editProfileButtonBackground = const Color(0xfff48a34);

  //galeriye gitmek için gerekli değişkenler
  XFile? imageFile;
  final imagePicker = ImagePicker();

  @override
  void initState() {
    _userModel = UserModel(
        id: 1,
        userName: "Ali Can",
        userSurname: "Aydın",
        userBirthday: "28",
        fallowed: 125,
        fallower: 220,
        sharingPhotoPath: [
         ],
        profilePhotoPath:
            "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        userContent:
            "Yazılım Mühendisiasdlkandsljandasdhlbajlsfljashkjfskjfkjsdbfkjsbfkjsbdfkjbskjdfbskjfbjksbfkjsbdkfjbsdkjfbksjdbfkjsdbfkjsdbfkjsbdfkjsdkfjbskjdfskjdfskjbdfsjkfbjksbfkjjsbfkjsbfkjskfjskjddtfbjksdbfkjsbfkjsbfkjbskjfbskjfbksjbfksjbfksjb",
        userRating: 4);
    _profilePhotoPath = _userModel!.profilePhotoPath.toString();
    _userName = _userModel!.userName.toString();
    _userSurname = _userModel!.userSurname.toString();
    _userBirthday = _userModel!.userBirthday.toString();
    _userRating = _userModel!.userRating;
    _userPhotos = _userModel!.sharingPhotoPath!.toList();
    _fallower = _userModel!.fallower;
    _fallowed = _userModel!.fallowed;
    _userContent = _userModel!.userContent;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        _profilePhotoPath!), // Profil resmi URL'i buraya
                  ),

                  Container(
                    width: width*0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              _fallower.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text('Takipçi'),
                          ],
                        ),
                        SizedBox(width: width*0.05,),
                        Column(
                          children: [
                            Text(
                              _fallowed.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text('Takip'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: width*0.2,

                      child: const Align(
                        alignment: Alignment.topRight,
                          child: const Icon(Icons.settings)))
                ],
              ),
              Row(
                children: [
                  Text(
                    '${_userName} ${_userSurname} ${_userBirthday}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: width*0.1,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        _userRating!,
                        (index) => const Icon(Icons.star, color: Colors.amber),
                      )
                    ],
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.centerLeft, child: Text(_userContent!)),
              SizedBox(
                height: width * 0.05,
              ),
              GestureDetector(
                child: Container(
                  width: width * 0.4,
                  child:   const Padding(
                    padding:  const EdgeInsets.all(8.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Profili Düzenle",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: _editProfileButtonBackground,
                      borderRadius: BorderRadius.circular(90)),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await selectImageFromGallery(context: context).then((value) {
                          imageFile=value;
                          showShareConfirmationDialog(context: context,sharingFunction: () {
                            setState(() {
                              _userPhotos!.add(imageFile!.path.toString());
                            });
                          },);
                        },);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: const Center(
                          child: Icon(Icons.add, size: 40, color: Colors.black),
                        ),
                      ),
                    ),
                    ...List.generate(
                      _userPhotos!.length,
                      (index) => Container(
                        width: 40,
                        height: 100,
                        child: Image.file(
                          File(_userPhotos![index]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
  void showShareConfirmationDialog({required BuildContext context,required VoidCallback sharingFunction}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Paylaşım Onayı'),
          content: Text('Bu Fotoğrafı paylaşmak istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
                Fluttertoast.showToast(msg: 'Paylaşım işlemi iptal edildi.'); // Kullanıcıya bilgi ver
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
                Fluttertoast.showToast(msg: 'Fotoğraf paylaşma işlemi başlatıldı.'); // Paylaşım başlatılıyor

                // Paylaşma işlemi burada yapılabilir
                sharingFunction();
                print("paylaşıldı");
              },
              child: Text('Paylaş'),
            ),
          ],
        );
      },
    );
  }

  Future<XFile?> selectImageFromGallery({required BuildContext context}) async {
    // Önce depolama iznini kontrol et
    var storagePermission = await Permission.storage.status;

    if (storagePermission.isGranted) {
      // İzin verilmişse galeriden resmi seç
      XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        //imageFile = pickedFile;
        // setState fonksiyonunu burada kullanmanız için widget context'ine ihtiyacınız var
        // Örneğin, StatefulWidget'ten çağırabilirsiniz veya imageFile değişikliğini bir
        // state yönetim çözümü ile (Provider, Bloc, vb.) yönetebilirsiniz.
        Fluttertoast.showToast(msg: 'Resim seçildi.');
        return pickedFile;
      } else {
        Fluttertoast.showToast(msg: 'Resim seçilmedi.');
        return null;
      }
    } else if (storagePermission.isDenied) {
      // İzin verilmemişse kullanıcıya tekrar sor
      var newStatus = await Permission.storage.request();
      if (newStatus.isGranted) {
        XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          //imageFile = pickedFile;
          Fluttertoast.showToast(msg: 'Resim seçildi.');
          return pickedFile;
        } else {
          Fluttertoast.showToast(msg: 'Resim seçilmedi.');
          return null;
        }
      } else {
        Fluttertoast.showToast(msg: 'Galeriye erişim izni reddedildi.');
      }
    } else if (storagePermission.isPermanentlyDenied) {
      // İzin kalıcı olarak reddedilmişse, ayarlara yönlendirme uyarısı göster
      await showPermissionDeniedDialog(context);
    }
    return null;
  }

// Kalıcı olarak reddedilen izin durumu için bir uyarı mesajı göster
  Future<void> showPermissionDeniedDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('İzin Gerekli'),
        content: Text(
            'Tekrar izin vermeniz için uygulama ayarlarına gitmeniz gerekmektedir.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings(); // Kullanıcıyı uygulama ayarlarına yönlendir
            },
            child: Text('Ayarlar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('İptal'),
          ),
        ],
      ),
    );
  }





}
