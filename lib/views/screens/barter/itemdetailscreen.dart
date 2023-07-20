import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barterit2/models/item.dart';
import 'package:barterit2/models/user.dart';
import 'package:barterit2/appconfig/myconfig.dart';
import 'billscreen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Catch usercatch;
  final User user;
  const ItemDetailsScreen({Key? key, required this.usercatch, required this.user}) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  String maintitle = "Item Detail";
  final df = DateFormat('dd-MM-yyyy hh:mm a');

  late double screenHeight, screenWidth, cardwitdh;
  List<Catch> catchList = [];
  Catch? selectedCatch;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: CachedNetworkImage(
                            width: screenWidth * 0.8,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${MyConfig().SERVER}/barterit/assets/catches/${widget.usercatch.catchId}_$i.png?v=${DateTime.now().millisecondsSinceEpoch}",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.usercatch.catchName.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(6),
                },
                children: [
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        widget.usercatch.catchDesc.toString(),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Item Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        widget.usercatch.catchType.toString(),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "QTY Available",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        widget.usercatch.catchQty.toString(),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "RM ${double.tryParse(widget.usercatch.catchPrice ?? '0.00')?.toStringAsFixed(2) ?? '0.00'}",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Location",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "${widget.usercatch.catchLocality}/${widget.usercatch.catchState}",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        df.format(DateTime.parse(widget.usercatch.catchDate.toString())),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _showCardForm(context);
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag),
            SizedBox(width: 8),
            Text("Barter Now"),
          ],
        ),
      ),
    );
  }

void _showCardForm(BuildContext context) async {
  if (widget.user.id == "") {
    // If user is not logged in, show a dialog prompting them to log in
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Please Login"),
          content: Text("You need to log in to use the card form."),
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
  } else {
    // Fetch the catches from the server using the user ID
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/load_catches.php"),
      body: {"userid": widget.user.id},
    ).then((response) {
      catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['catches'].forEach((v) {
            catchList.add(Catch.fromJson(v));
          });
        }
        setState(() {
          // Show the list of catches in the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Select an item"),
                content: Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: catchList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(catchList[index].catchName ?? "Unknown Name"),
                        subtitle: Text("RM ${double.tryParse(catchList[index].catchPrice ?? '0.00')?.toStringAsFixed(2) ?? '0.00'}"),
                        onTap: () {
                          double selectedPrice = double.tryParse(catchList[index].catchPrice ?? '0.00') ?? 0.00;
                          double catchPrice = double.tryParse(widget.usercatch.catchPrice ?? '0.00') ?? 0.00;
                          double totalPay = catchPrice - selectedPrice;

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Bartering"),
                                content: Text("You want to barter ${widget.usercatch.catchName} for RM ${selectedPrice.toStringAsFixed(2)}.\n\nTotal Pay: RM ${totalPay.toStringAsFixed(2)}"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BillScreen( 
                                            user: widget.user,
                                            totalprice: totalPay,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
      } else {
        // Handle server communication errors
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to fetch items. Please try again later."),
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
    });
  }
}

}
