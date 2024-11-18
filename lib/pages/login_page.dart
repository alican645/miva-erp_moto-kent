import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:http/http.dart' as http;
import 'package:moto_kent/constants/api_constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_kent/widgets/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  // Kullanıcı giriş yapma fonksiyonu
  void signUserIn(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    var url = Uri.parse(ApiConstants.loginEndpoint);

    try {
      // Spinner başlat
      _isLoading.value = true;

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        String token = jsonResponse['token'];
        String refreshToken = jsonResponse['refreshToken'];
        String expiration = jsonResponse['expiration'];
        String userId = jsonResponse['userId']; // Kullanıcı ID'sini aldık

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('token_expiration', expiration);
        await prefs.setString('user_id', userId); // Kullanıcı ID'sini kaydettik

        context.go('/profile_page');
      }
      else {
        var errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        String errorMessage = errorResponse['Errors']?.first ?? 'Beklenmeyen bir hata oluştu.';
        _showErrorDialog(context, 'Giriş Başarısız', errorMessage);
      }
    } catch (e) {
      _showErrorDialog(context, 'Hata', 'Sunucuda bir hata oluştu. Lütfen daha sonra tekrar deneyin.');
    } finally {
      _isLoading.value = false; // Spinner'ı kapat
    }
  }

  // Hata mesajı gösteren dialog
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
        child: ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) {
            return LoadingOverlay(
              isLoading: isLoading,
              child: SingleChildScrollView( // Ekranın kaydırılabilir olmasını sağlar
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const Icon(Icons.lock, size: 100),
                      const SizedBox(height: 50),
                      Text(
                        "MotoKent'e Hoşgeldiniz!",
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: usernameController,
                        hintText: 'E-mail',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Şifre',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Şifremi Unuttum', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      MyButton(
                        onTap: () => signUserIn(context),
                        text: "Giriş Yap",
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Üye değil misiniz?', style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              context.go('/register_page');
                            },
                            child: const Text(
                              'Şimdi kayıt olun!',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50), // Alt boşluk
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
