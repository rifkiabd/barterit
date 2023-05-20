// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:barterit2/models/user.dart';
import 'package:barterit2/views/screens/loginscreen.dart';
import 'package:barterit2/views/screens/registrationscreen.dart';

class AccountTabScreen extends StatefulWidget {
  final User user;

  const AccountTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AccountTabScreenState createState() => _AccountTabScreenState();
}

class _AccountTabScreenState extends State<AccountTabScreen> {
  late double screenHeight, screenWidth, cardWidth;
  String maintitle = "Account";

  @override
  void initState() {
    super.initState();
    print("Account");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.25,
              width: screenWidth,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(4),
                      width: screenWidth * 0.4,
                      child: Image.asset(
                        "assets/images/account.png",
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(widget.user.email.toString()),
                          Text(widget.user.phone.toString()),
                          Text(widget.user.datereg.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth,
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "ACCOUNT SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: const Text('Registration'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
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
