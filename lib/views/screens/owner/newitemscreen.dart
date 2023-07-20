// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barterit2/models/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:barterit2/appconfig/myconfig.dart';

class NewCatchScreen extends StatefulWidget {
  final User user;

  const NewCatchScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<NewCatchScreen> createState() => _NewCatchScreenState();
}

class _NewCatchScreenState extends State<NewCatchScreen> {
  final List<File?> _images = List.generate(3, (_) => null);
  var pathAsset = "assets/images/barterit.jpg";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardWidth;
  final TextEditingController _catchnameEditingController =
      TextEditingController();
  final TextEditingController _catchdescEditingController =
      TextEditingController();
  final TextEditingController _catchpriceEditingController =
      TextEditingController();
  final TextEditingController _catchqtyEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  String selectedType = "Electronics";
  List<String> catchlist = [
    "Electronics",
    "Collectibles",
    "Jewelry",
    "Clothing",
    "Accessories",
    "Artwork",
    "Books",
    "Equipment",
    "Other",
  ];
  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert New Item"),
        actions: [
          IconButton(
            onPressed: () {
              _determinePosition();
              _refresh();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _selectFromCamera(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _images[index] == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_images[index]!) as ImageProvider<Object>,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.type_specimen),
                          const SizedBox(width: 16),
                          SizedBox(
                            height: 60,
                            child: DropdownButton(
                              value: selectedType,
                              onChanged: (newValue) {
                                setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: catchlist.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Item name must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {},
                              controller: _catchnameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.abc),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        )
                      ],
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 4,
                        controller: _catchdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Product price must contain value"
                                  : null,
                              onFieldSubmitted: (v) {},
                              controller: _catchpriceEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Item Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity should be more than 0"
                                  : null,
                              controller: _catchqtyEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Item Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.numbers),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State"
                                : null,
                            enabled: false,
                            controller: _prstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _prlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text("Insert Item")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

Future<void> _selectFromCamera(int index) async {
  final picker = ImagePicker();
  List<XFile>? pickedFiles = await picker.pickMultiImage(
    maxHeight: 1200,
    maxWidth: 800,
  );

  if (pickedFiles.isNotEmpty) {
    for (int i = 0; i < pickedFiles.length && i < 3; i++) {
      _images[index + i] = File(pickedFiles[i].path);
      await cropImage(index + i);
    }
  } else {
    print('No images selected.');
  }
}

Future<void> cropImage(int index) async {
  if (_images[index] != null) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _images[index]!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      _images[index] = File(croppedFile.path);
      int? sizeInBytes = await _images[index]?.length();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);

      setState(() {});
    }
  }
}


 void insertDialog() {

  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Check your input")));
    return;
  }

 if (_images.length != 3 || _images.contains(null)) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Please select 3 pictures")),
  );
  return;
}

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertCatch();
                //registerUser();
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

  void insertCatch() {
    String catchname = _catchnameEditingController.text;
    String catchdesc = _catchdescEditingController.text;
    String catchprice = _catchpriceEditingController.text;
    String catchqty = _catchqtyEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    List<String> base64Images = [];
      for (var image in _images) {
        if (image != null) {
          String base64Image = base64Encode(image.readAsBytesSync());
          base64Images.add(base64Image);
        }
      }
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/insert_catch.php"),
        body: {
          "userid": widget.user.id.toString(),
          "catchname": catchname,
          "catchdesc": catchdesc,
          "catchprice": catchprice,
          "catchqty": catchqty,
          "type": selectedType,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "images": jsonEncode(base64Images)
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
  
  void _refresh() 
  { setState(() {
      _images.clear();
      _images.addAll(List.generate(3, (_) => null));
      _catchnameEditingController.text = '';
      _catchdescEditingController.text = '';
      _catchpriceEditingController.text = '';
      _catchqtyEditingController.text = '';
      _prstateEditingController.text = '';
      _prlocalEditingController.text = '';
      selectedType = "Electronics";
    });}
}