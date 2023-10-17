import 'package:book/New/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../model/book.dart';
import '../model/new.dart';
import 'dart:convert';

class NetworkServices {
  static Future<List<Book>> fetchData() async {
    final response = await http.get(Uri.parse('https://api.itbook.store/1.0/new'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      return New.fromJson(jsonData).books;
    } else {
      Fluttertoast.showToast(msg: 'Error occurred. ${response.statusCode}');
      throw Exception('API 요청 실패: ${response.statusCode}');
    }
  }

  static Future<void> fetchBookDetail(BuildContext context, String isbn13) async {
    final response =
        await http.get(Uri.parse('https://api.itbook.store/1.0/books/$isbn13'));

    if (response.statusCode == 200) {
      final result =
          Book.fromJson(json.decode(response.body) as Map<String, dynamic>);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(bookDetail: result)),
      );
    } else {
      Fluttertoast.showToast(msg: 'Error occurred. ${response.statusCode}');
      throw Exception('API 요청 실패: ${response.statusCode}');
    }
  }

  static Future<New> fetchSearch(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse('https://api.itbook.store/1.0/search/$query/$page'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      return New.fromJson(jsonData);
    } else {
      Fluttertoast.showToast(msg: 'Error occurred. ${response.statusCode}');
      throw Exception('API 요청 실패: ${response.statusCode}');
    }
  }
}
