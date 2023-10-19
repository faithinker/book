import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/model/book.dart';
import '../../services/networkServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'detail_screen.dart';

// https://velog.io/@sht-3756/Flutter-클릭을-방지하는-위젯

class NewTile extends StatefulWidget {
  final Book book;

  const NewTile({
    super.key,
    required this.book,
  });

  @override
  _NewTileState createState() => _NewTileState();
}

class _NewTileState extends State<NewTile> {
  bool _isButtonPressed = false;

  Future<void> _handleOnTap(BuildContext context) async {
    if (_isButtonPressed) return;

    try {
      _isButtonPressed = true;
      final result = await NetworkServices.fetchBookDetail(widget.book.isbn13);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(bookDetail: result)),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error occurred. $e');
    } finally {
      _isButtonPressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 310,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(widget.book.url));
                      },
                      child: const Icon(
                        Icons.link,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _handleOnTap(context),
                  child: Container(
                    child: Image.network(
                      widget.book.image,
                      width: 200,
                      height: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 110.0,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            widget.book.title,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.book.subtitle,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.book.price,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}
