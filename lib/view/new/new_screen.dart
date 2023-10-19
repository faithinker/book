import 'package:flutter/material.dart';
import '../../model/book.dart';
import 'package:book/view/new/new_tile.dart';

class NewScreen extends StatelessWidget {
  final List<Book> bookList;

  const NewScreen({
    super.key,
    required this.bookList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              child: const Text(
                'New Books',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: bookList.length,
                itemBuilder: (context, index) {
                  final book = bookList[index];
                  return NewTile(book: book);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
