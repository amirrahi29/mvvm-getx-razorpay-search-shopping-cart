import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm/view/MyHomePage.dart';
import 'package:flutter_mvvm/view/PaymentStatus.dart';
import 'package:flutter_mvvm/view_model/ProductViewModel.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;
  ProductViewModel productViewModel = Get.put(ProductViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_CJTp8VyH994tC1',
      'amount': productViewModel.totalPrice.toInt()*100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    productViewModel.clearCart();
    Get.offAll(PaymentStatus(),
    arguments: "1");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Get.offAll(PaymentStatus(),
        arguments: "0");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    productViewModel.clearCart();
    Get.offAll(PaymentStatus(),
        arguments: "1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        actions: [
          InkWell(
            onTap: ()
            {
              productViewModel.clearCart();
              Get.offAll(MyHomePage());
            },
            child: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text("Clear All"),
            ),
          )
        ],
      ),
      body: Obx(()=>
          Stack(
            children: [

              ListView.builder(
                  itemCount: productViewModel.cartList.length,
                  itemBuilder: (context,index){
                    return Container(
                        margin: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Row(
                              children: <Widget>[

                                Container(
                                  height: 50,
                                  width: 50,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                          image: NetworkImage(productViewModel.cartList[index].image!)
                                      )
                                  ),
                                ),

                                Expanded(
                                  child: Container(
                                    child: Text(productViewModel.cartList[index].title!,),
                                  ),
                                ),

                                InkWell(
                                  onTap: (){
                                    productViewModel.removeFromCart(productViewModel.cartList[index]);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: Icon(Icons.delete_outline_sharp,color: Colors.red,),
                                  ),
                                )

                              ],
                            ),
                            Container(
                              child: Text("Rs."+productViewModel.productList[index].price!.toString(),
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            ),
                            Divider(),

                          ],
                        )
                    );
                  }
              ),

              Positioned(
                bottom: 100,
                child: Card(
                  color: Colors.brown,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Obx(()=>Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Container(
                          child: Text("${productViewModel.count} products available",
                            style: TextStyle(color: Colors.white),),
                        ),

                        Container(
                          child: Text("Total Price: Rs.${productViewModel.totalPrice}",
                          style: TextStyle(color: Colors.white),),
                        )

                      ],
                    ))
                  ),
                ),
              )

            ],
          )
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            openCheckout();
          },
          label: Text("Checkout")
      ),
    );
  }
}
