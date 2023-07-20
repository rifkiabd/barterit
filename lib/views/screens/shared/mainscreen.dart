// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:barterit2/views/screens/shared/accounttabscreen.dart';
import 'package:barterit2/views/screens/shared/ideastabscreen.dart';

import '../../../models/user.dart';
import 'bartertabscreen.dart';

import '../owner/itemtabscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Barter";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("Mainscreen");
    tabchildren = [
      BarterTabScreen(user: widget.user,),
      ItemTabScreen(user: widget.user,),
      NewsTabScreen(user: widget.user),
      AccountTabScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.change_circle_rounded,
                ),
                label: "Barter"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_basket,
                ),
                label: "Item"),    
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.lightbulb,
                ),
                label: "Ideas"),    
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                ),
                label: "Account"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Barter";
      }
      if (_currentIndex == 1) {
        maintitle = "Item";
      }
      if (_currentIndex == 2) {
        maintitle = "Ideas";
      }
      if (_currentIndex == 3) {
        maintitle = "Account";
      }
    });
  }
}