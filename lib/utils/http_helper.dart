import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  // Asenkron HTTP isteği
  static Future<void> performRequest({
    required BuildContext context,
    required Future<http.Response> Function() request,
    required ValueNotifier<bool> isLoadingNotifier,
  }) async {
    try {
      isLoadingNotifier.value = true; // İstek başlamadan önce isLoading true yap
      final response = await request();
      if (response.statusCode == 200) {
        print('Başarılı: ${response.body}');
      } else {
        print('Hata: ${response.statusCode}');
      }
    } catch (e) {
      print('İstek hatası: $e');
    } finally {
      isLoadingNotifier.value = false; // İstek tamamlandığında isLoading false yap
    }
  }
}
