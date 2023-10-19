import 'package:flutter/material.dart';
import 'package:book/new/newScreen.dart';
import 'model/book.dart';
import '/services/networkServices.dart';
import 'search/searchScreen.dart';

void greet(String name) {
  print("Hello, $name!");
}

class TabApp extends StatefulWidget {
  const TabApp({super.key});

  @override
  _TabAppState createState() => _TabAppState();
}

class _TabAppState extends State<TabApp> {
  List<Book> _book = <Book>[];
  bool loading = false;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    NetworkServices.fetchData().then((value) {
      setState(() {
        _book = value;
        loading = false;
      });
      // greet('joohyp');
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _getPage(_currentIndex, _book),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
        backgroundColor: Colors.white30,
      ),
    );
  }
}

Widget _getPage(int index, List<Book> bookList) {
  switch (index) {
    case 0:
      return NewScreen(bookList: bookList);
    case 1:
      return const SearchScreen();
    default:
      return Container();
  }
}
