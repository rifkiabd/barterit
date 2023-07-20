// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit2/models/item.dart';
import 'package:barterit2/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit2/appconfig/myconfig.dart';
import '../barter/itemdetailscreen.dart';
import 'newitemscreen.dart';

class ItemTabScreen extends StatefulWidget {
  final User user;

  const ItemTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ItemTabScreen> createState() => _ItemTabScreenState();
}

class _ItemTabScreenState extends State<ItemTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Barter Item";
  List<Catch> catchList = <Catch>[];

  @override
  void initState() {
    super.initState();
    loadbarterCatches();
    print("Barter Item");
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
                    "${catchList.length} Items Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(
                      catchList.length,
                      (index) {
                        return Card(
                          child: InkWell(
                            onLongPress: () {
                              onDeleteDialog(index);
                            },
                            onTap: () async {
                              Catch singlecatch =
                                  Catch.fromJson(catchList[index].toJson());
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (content) => ItemDetailsScreen(
                                    user: widget.user,
                                    usercatch: singlecatch,
                                  ),
                                ),
                              );
                              loadbarterCatches();
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().SERVER}/barterit/assets/catches/${catchList[index].catchId}_0.png?v=${DateTime.now().millisecondsSinceEpoch}",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Text(
                                  catchList[index].catchName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "RM ${double.parse(catchList[index].catchPrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${catchList[index].catchQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.user.id != "") {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (content) => NewCatchScreen(
                  user: widget.user,
                ),
              ),
            );
            loadbarterCatches();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please login/register an account"),
              ),
            );
          }
        },
        child: const Text(
          "+",
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  void loadbarterCatches() {
    if (widget.user.id == "") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http
        .post(
          Uri.parse("${MyConfig().SERVER}/barterit/load_catches.php"),
          body: {"userid": widget.user.id},
        )
        .then((response) {
      //print(response.body);
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

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Delete ${catchList[index].catchName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteCatch(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
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

  void deleteCatch(int index) {
    http
        .post(
          Uri.parse("${MyConfig().SERVER}/barterit/delete_catch.php"),
          body: {
            "userid": widget.user.id,
            "catchid": catchList[index].catchId,
          },
        )
        .then((response) {
      print(response.body);
      //catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Delete Success")),
          );
          loadbarterCatches();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed")),
          );
        }
      }
    });
  }
}
