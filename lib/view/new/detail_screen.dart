import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/model/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Book bookDetail;

  const DetailScreen({
    super.key,
    required this.bookDetail,
  });

  @override
  _DetailScreen createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadMemo();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  void saveMemo() async {
    prefs.setString(widget.bookDetail.isbn13, _textEditingController.text);
  }

  void loadMemo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _textEditingController.text =
          prefs.getString(widget.bookDetail.isbn13) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        saveMemo();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Book'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  color: Colors.grey,
                  child: Image.network(
                    widget.bookDetail.image,
                  ),
                ),
                Container(
                  height: 500,
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      SelectableText(
                        widget.bookDetail.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SelectableText(
                        widget.bookDetail.subtitle,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SelectableText(
                        "isbn: ${widget.bookDetail.isbn13}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                      SelectableText(
                        "가격: ${widget.bookDetail.price}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(widget.bookDetail.url));
                        },
                        child: Text(
                          widget.bookDetail.url,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        maxLines: 8,
                        onTap: () {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent + 300,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        decoration: const InputDecoration(
                          hintText: '메모를 입력해주세요.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// DS네트웍스  시행사(디벨로퍼), 시공사, 감리단