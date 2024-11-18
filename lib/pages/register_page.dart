import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/widgets/loading_overlay.dart';
import 'package:moto_kent/utils/http_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  // Register user method
  void registerUser(BuildContext context) async {
    final fullName = fullNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      _showErrorDialog(context, 'Hata', 'Şifreler eşleşmiyor.');
      return;
    }

    await HttpHelper.performRequest(
      context: context,
      isLoadingNotifier: _isLoading,
      request: () async {
        final url = Uri.parse(ApiConstants.registerEndpoint);
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'fullName': fullName,
            'email': email,
            'password': password,
            'confirmPassword': confirmPassword,
          }),
        );

        if (response.statusCode == 201) {
          // Kayıt başarılı, kullanıcıya bilgi ver
          if (context.mounted) {
            _showSuccessDialog(context, 'Başarılı', 'Kayıt başarılı bir şekilde gerçekleşti. Giriş sayfasına yönlendiriliyorsunuz.');
          }
        } else {
          // Hata mesajını backend'den al ve göster
          final errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
          if (errorResponse['Errors'] != null && errorResponse['Errors'].isNotEmpty) {
            if (context.mounted) {
              _showErrorDialog(context, 'Kayıt Başarısız', errorResponse['Errors'][0]);
            }
          } else {
            if (context.mounted) {
              _showErrorDialog(context, 'Kayıt Başarısız', 'Beklenmeyen bir hata oluştu.');
            }
          }
        }
        return response;
      },
    );
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

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/login_page');
              },
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0), // Alt kısma ek boşluk
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // Logo
                      const Icon(
                        Icons.person_add,
                        size: 100,
                      ),

                      const SizedBox(height: 50),

                      // "MotoKent'e hoş geldiniz" başlığı
                      Text(
                        "MotoKent'e Hoşgeldiniz!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24, // Daha büyük font boyutu
                          fontWeight: FontWeight.bold, // Kalın yazı stili
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Hoş geldiniz
                      Text(
                        "Yeni bir hesap oluşturun",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Ad soyad textfield
                      MyTextField(
                        controller: fullNameController,
                        hintText: 'Ad Soyad',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      // Email textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      // Şifre textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Şifre',
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),

                      // Şifre tekrar textfield
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Şifre Tekrar',
                        obscureText: true,
                      ),

                      const SizedBox(height: 25),

                      // Kayıt ol butonu
                      MyButton(
                        onTap: () => registerUser(context),
                        text: "Kayıt Ol",
                      ),

                      const SizedBox(height: 50),

                      // Zaten üye misiniz? Giriş yapın
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Zaten üye misiniz?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              context.go('/login_page');
                            },
                            child: const Text(
                              'Kayıt Ol!',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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
