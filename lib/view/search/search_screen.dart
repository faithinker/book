import 'package:book/view/search/search_tile.dart';
import 'package:book/services/networkServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/book.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  late TextEditingController _textController;
  final ScrollController _scrollController = ScrollController();

  List<Book> books = [];

  var page = 1;
  var totalPage = 20;
  var query = '';
  var isFirstLoading = false;
  var loadMore = false;
  bool hiddenNoResultText = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    _textController.addListener(() {
      if (_textController.text.isNotEmpty && books.isEmpty) {
        setState(() {
          _scrollListener();
          hiddenNoResultText = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    //_scrollController.position.extentAfter < 100  // 스크롤이 가능한 Viewport
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        page < totalPage) {
      _loadMoreData();
    }
  }

  void _loadMoreData() async {
    page += 1;
    setState(() {
      loadMore = true;
    });
    print('object: $page totalPage: $totalPage    $query');
    try {
      await NetworkServices.fetchSearch(query, page: page).then((value) {
        setState(() {
          books.addAll(value.books);
        });
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      // try 블록에서 예외가 발생하든 안 하든 항상 실행되는 코드
      setState(() {
        loadMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Search Books',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CupertinoSearchTextField(
              controller: _textController,
              placeholder: '검색어를 입력해보세요.',
              onChanged: (value) {},
              onSubmitted: (String value) async {
                page = 1;
                query = value;
                await NetworkServices.fetchSearch(value).then((value) {
                  setState(() {
                    books = value.books;
                    hiddenNoResultText = value.books.isEmpty;
                    totalPage = int.tryParse(value.total) ?? 0;
                    int remainder = totalPage % 10 == 0 ? 0 : 1;
                    int quotient = totalPage ~/ 10;
                    totalPage = quotient + remainder;
                    print(
                        'fetchSearch Result: $page, $totalPage ${value.books.length}');
                  });
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: books.length + 1,
                      itemBuilder: (context, index) {
                        if (index < books.length) {
                          return SearchTile(book: books[index]);
                        } else {
                          if (loadMore) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Visibility(
                    visible: hiddenNoResultText,
                    child: const Center(
                      child: Text(
                        '검색 결과가 없습니다.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
