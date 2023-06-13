import 'package:flutter/material.dart';
import 'package:barterit2/models/user.dart';
import 'barteringtabscreen.dart';

class BarterTabScreen extends StatefulWidget {
  final User user;

  const BarterTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  _BarterTabScreenState createState() => _BarterTabScreenState();
}

class _BarterTabScreenState extends State<BarterTabScreen> {
  String maintitle = "Barter";

  @override
  void initState() {
    super.initState();
    print("Barter");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/barterit2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarteringTabScreen(user: widget.user),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Go Barter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
