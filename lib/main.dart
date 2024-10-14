import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/HomePage.dart';
import 'package:moto_kent/Router.dart';
Color _categorySelectionBarColor = const Color(0xfff48a34);
void main() {
  runApp(const MyApp(),);

  // Sistem UI ayarlarını uygulayın
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(

      statusBarColor: Colors.transparent, // Durum çubuğunu şeffaf yapar
      statusBarIconBrightness: Brightness.dark, // İkonların rengini ayarlar (örneğin: koyu)

      // Navigation bar rengini değiştirir
      systemNavigationBarColor: _categorySelectionBarColor, // Alt kısımda yer alan geri ve ana ekran tuşlarının arka plan rengini ayarlar
      systemNavigationBarIconBrightness: Brightness.dark, // Alt kısımdaki ikonların rengini ayarlar (örneğin: kapalı)
    ),
  );
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: AppTheme.themeData,
    );
  }
}



