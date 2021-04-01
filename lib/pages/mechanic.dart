import 'package:flutter/material.dart';
import 'package:vehicel_assistance/pages/mechanichome.dart';
import 'package:vehicel_assistance/pages/mjobs.dart';
import 'package:vehicel_assistance/pages/mprofile.dart';

class Mechanic extends StatefulWidget{
@override
  _MState createState() => _MState();
}

class _MState extends State<Mechanic> {
PageController _pageController = PageController();
  List<Widget> _screens = [
    MechanicHome(),
    MProfile(),
    MJobs(),
  ];
  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: _selectedIndex == 0 ? Colors.cyan : Colors.grey,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                  color: _selectedIndex == 0 ? Colors.cyan : Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
              color: _selectedIndex == 1 ? Colors.cyan : Colors.grey,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                  color: _selectedIndex == 1 ? Colors.cyan : Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              color: _selectedIndex == 2 ? Colors.cyan : Colors.grey,
            ),
            title: Text(
              'Jobs',
              style: TextStyle(
                  color: _selectedIndex == 2 ? Colors.cyan : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}