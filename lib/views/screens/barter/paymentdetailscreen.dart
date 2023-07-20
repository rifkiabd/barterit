import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barterit2/models/payment.dart';
import 'package:barterit2/appconfig/myconfig.dart';
import 'package:barterit2/models/user.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final User user;

  const PaymentDetailsScreen({super.key, required this.user});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  List<Payment> payments = [];

  @override
  void initState() {
    super.initState();
    _loadPaymentData();
  }

  void _loadPaymentData() async {
    var url = "${MyConfig().SERVER}/barterit/load_payment.php";
    var response = await http.post(
      Uri.parse(url),
      body: {"userid": widget.user.id},
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "success") {
        var paymentData = jsonData['data']['payments'];
        List<Payment> loadedPayments = [];
        for (var payment in paymentData) {
          loadedPayments.add(Payment.fromJson(payment));
        }
        setState(() {
          payments = loadedPayments;
        });
      } else {
        // Handle server response indicating failure
      }
    } else {
      // Handle HTTP error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Payment ID: ${payments[index].paymentId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${payments[index].userId}'),
                Text('Payment Date: ${payments[index].paymentDate}'),
                Text('Payment Status: ${payments[index].paymentStatus}'),
                Text('Amount: RM ${payments[index].amount}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
