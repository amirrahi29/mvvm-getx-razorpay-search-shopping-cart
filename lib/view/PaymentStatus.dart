import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({Key? key}) : super(key: key);

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {

  var data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: data == 1?
            Text("Payment failed!",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 32),)
            :Text("Payment success!",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 32),),
      ),
    );
  }
}
