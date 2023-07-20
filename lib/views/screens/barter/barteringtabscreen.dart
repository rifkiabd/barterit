import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit2/models/item.dart';
import 'package:barterit2/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit2/appconfig/myconfig.dart';

import 'itemdetailscreen.dart';
import 'paymentdetailscreen.dart';

class BarteringTabScreen extends StatefulWidget {
  final User user;
  const BarteringTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<BarteringTabScreen> createState() => _BarteringTabScreenState();
}

class _BarteringTabScreenState extends State<BarteringTabScreen> {
  String maintitle = "Bartering";
  List<Catch> catchList = <Catch>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late int currentPage = 1;
  int catchesPerPage = 6; 
  late int totalPages = 0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCatches();
    print("Bartering");
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
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
             actions: [
        IconButton(
          onPressed: () {
            showsearchDialog();
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            if (widget.user.id != "" ) {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentDetailsScreen(user: widget.user),
                ),
              );
            } else {
              _showLoginText();
            }
          },
          icon: const Icon(Icons.payment),
        ),
      ],
      ),
      body: catchList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    "${catchList.length} Item Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(
                      catchesPerPage,
                      (index) {
                        final catchIndex = (currentPage - 1) * catchesPerPage + index;
                        if (catchIndex < catchList.length) {
                          final catchItem = catchList[catchIndex];
                          return Card(
                            child: InkWell(
                              onTap: () async {
                                Catch singlecatch = Catch.fromJson(catchItem.toJson());
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => ItemDetailsScreen(
                                      user: widget.user,
                                      usercatch: singlecatch,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      width: screenWidth,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "${MyConfig().SERVER}/barterit/assets/catches/${catchItem.catchId}_0.png?v=${DateTime.now().millisecondsSinceEpoch}",
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Text(
                                    catchItem.catchName.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "RM ${double.parse(catchItem.catchPrice.toString()).toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${catchItem.catchQty} available",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     ElevatedButton(
                        onPressed: currentPage > 1 ? previousPage : null,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.arrow_circle_left,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text("Page"),
                          ],
                        ),
                      ),
                      Text(
                        "Page $currentPage of $totalPages",
                        style: TextStyle(fontSize: 18),
                      ),
                     ElevatedButton(
                      onPressed: currentPage < totalPages ? nextPage : null,
                      child: Row(
                        children: const [
                          Text("Page"),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_circle_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void loadCatches() {
    http
        .post(
          Uri.parse("${MyConfig().SERVER}/barterit/load_catches.php"),
          body: {},
        )
        .then((response) {
      log(response.body);
      catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['catches'].forEach((v) {
            catchList.add(Catch.fromJson(v));
          });
          print(catchList[0].catchName);
          calculateTotalPages(); // Calculate the total number of pages
        }
        setState(() {});
      }
    });
  }

  void calculateTotalPages() {
    totalPages = (catchList.length / catchesPerPage).ceil();
  }

  void previousPage() {
    setState(() {
      currentPage--;
    });
  }
  void nextPage() {
    setState(() {
      currentPage++;
    });
  }


  void showsearchDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        title: const Text(
          "Search?",
          style: TextStyle(),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchCatch(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "Close",
              style: TextStyle(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void searchCatch(String search) {
  http
      .post(
        Uri.parse("${MyConfig().SERVER}/barterit/load_catches.php"),
        body: {"search": search},
      )
      .then((response) {
    log(response.body);
    catchList.clear();
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['catches'].forEach((v) {
          catchList.add(Catch.fromJson(v));
        });
        print(catchList[0].catchName);
      }
      setState(() {});
    }
  });
}

void _showLoginText() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Please Login"),
        content: Text("You need to log in to use the payment feature."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

}