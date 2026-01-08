import 'package:flutter/material.dart';
import 'navbar_widget.dart';
import '../data/notifiers.dart';
import '../pages/home_page.dart';
import '../pages/my_books_page.dart';
import '../pages/profile_page.dart';

List<Widget> pages = [
  const HomePage(),
  const MyBooksPage(),
  const ProfilePage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (context, selectedIndex, child) {
          return pages.elementAt(selectedIndex);
        },
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
