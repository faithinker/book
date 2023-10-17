import 'dart:convert';
import 'book.dart';

List<Book> newFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => New.fromJson(x)));

class New {
  final String total; // 전체 책의 갯수
  final String error;
  final String page; // 현재 페이지

  List<Book> books; // 한 리스트에 10개씩 끊어서 보여줌

  New({
    required this.total,
    required this.error,
    required this.books,
    required this.page,
  });

  factory New.fromJson(Map<String, dynamic> json) {
    final List<dynamic> bookList = json['books'] ?? [];
    final List<Book> parsedBooks =
        bookList.map((book) => Book.fromJson(book)).toList();

    return New(
        total: json['total'] ?? '0',
        error: json['error'] ?? 'nil',
        page: json['page'] ?? '1',
        books: parsedBooks);
  }
}
