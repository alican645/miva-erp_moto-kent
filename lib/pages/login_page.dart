import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:http/http.dart' as http;
import 'package:moto_kent/constants/api_constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    var url = Uri.parse(ApiConstants.loginEndpoint);

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı giriş, gelen verileri parse et ve kaydet
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8 decode
        String token = jsonResponse['token'];
        String refreshToken = jsonResponse['refreshToken'];
        String expiration = jsonResponse['expiration'];

        // SharedPreferences ile verileri kaydet
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('token_expiration', expiration);

        // Başarılı girişten sonra yönlendirme
        context.go('/post_screen_page');
      } else {
        // Hata mesajını backend'den al ve göster
        var errorResponse = jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8 decode

        if (errorResponse['Errors'] != null && errorResponse['Errors'].isNotEmpty) {
          _showErrorDialog(context, 'Giriş Başarısız', errorResponse['Errors'][0]);
        } else {
          _showErrorDialog(context, 'Giriş Başarısız', 'Beklenmeyen bir hata oluştu.');
        }
      }
    } catch (e) {
      _showErrorDialog(context, 'Hata', 'Sunucuda bir hata oluştu. Lütfen daha sonra tekrar deneyin.');
    }
  }


  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // hoşgeldiniz geri döndünüz!
              Text(
                "MOTOKENT'e hoşgeldiniz!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // kullanıcı adı textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Kullanıcı Adı',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // şifre textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Şifre',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // şifremi unuttum?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Şifremi Unuttum',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // giriş yap butonu
              MyButton(
                onTap: () => signUserIn(context), // signUserIn fonksiyonunu çağır
              ),

              const SizedBox(height: 50),


              // üye değil misiniz? şimdi kayıt olun
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Üye değil misiniz?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Şimdi kayıt olun!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
