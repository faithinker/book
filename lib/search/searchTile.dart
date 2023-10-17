import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/book.dart';
import 'package:book/services/networkServices.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchTile extends StatefulWidget {
  final Book book;

  SearchTile({
    required this.book,
  });

  @override
  _SearchTile createState() => _SearchTile();
}

class _SearchTile extends State<SearchTile> {

  bool _isButtonPressed = false;

  Future<void> _handleOnTap(BuildContext context) async {
    if (_isButtonPressed) return;

    try {
      _isButtonPressed = true;
      await NetworkServices.fetchBookDetail(context, widget.book.isbn13);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error occurred. ${e}');
    } finally {
      _isButtonPressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => { _handleOnTap(context) },
      child: Container(
        child: Row(
          children: [
            Container(
              child: Image.network(
                widget.book.image,
                width: 80,
                height: 100,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    child: Text(
                      widget.book.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  DefaultTextStyle(
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 14.0,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    child: Text(
                      widget.book.subtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    widget.book.isbn13,
                  ),
                  Text(
                    '${widget.book.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SelectableText(
                    widget.book.url,
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}