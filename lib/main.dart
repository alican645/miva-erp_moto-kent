import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_kent/router.dart'; // Router dosya
// sını import edin

Color _categorySelectionBarColor = const Color(0xfff48a34);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Bu satır async kullanımı için gerekli
  String initialRoute = await getInitialRoute(); // İlk rotayı belirlemek için token kontrolü yapılacak

  runApp(MyApp(initialRoute: initialRoute));

  // Sistem UI ayarlarını uygulayın
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Durum çubuğunu şeffaf yapar
      statusBarIconBrightness: Brightness.dark, // İkonların rengini ayarlar (örneğin: koyu)
      systemNavigationBarColor: _categorySelectionBarColor, // Alt kısımda yer alan geri ve ana ekran tuşlarının arka plan rengini ayarlar
      systemNavigationBarIconBrightness: Brightness.dark, // Alt kısımdaki ikonların rengini ayarlar (örneğin: kapalı)
    ),
  );
}

Future<String> getInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwt_token');

  // Eğer token varsa, anasayfaya yönlendir
  if (token != null && token.isNotEmpty) {
    return "/home_page"; // Anasayfa için rotayı döndür
  } else {
    return "/login_page"; // Giriş sayfası için rotayı döndür
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // Router'ı kullanarak uygulamayı başlatın
      title: 'MotoKent',
      theme: AppTheme.themeData,
    );
  }
}
