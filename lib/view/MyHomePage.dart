import 'package:flutter/material.dart';
import 'package:flutter_mvvm/view/CartPage.dart';
import 'package:flutter_mvvm/view_model/ProductViewModel.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ProductViewModel productViewModel = Get.put(ProductViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(()=>Text("Total Price: "+productViewModel.totalPrice.toString()),),
        actions: [
          InkWell(
            onTap: (){
              Get.to(CartPage());
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[

                  Icon(Icons.shopping_cart),
                  Obx(()=>Text(productViewModel.count.toString()))

                ],
              ),
            ),
          )
        ],
      ),
      body: Obx(()=>
      productViewModel.isLoading.value?
          Center(
            child: CircularProgressIndicator(),
          )
          :
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search here....'
                    ),
                    onChanged: (value){
                      productViewModel.onTextChanged(value);
                    },
                  ),
                ),
                SizedBox(height: 16,),
                
                Expanded(
                  child: ListView.builder(
                      itemCount: productViewModel.searchList.length,
                      itemBuilder: (context,index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              height: 200,
                              width: double.infinity,
                              child: Image.network(productViewModel.searchList[index].image!),
                            ),

                            Container(
                              child: Text("Rs."+productViewModel.searchList[index].price!.toString(),
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            ),

                            Container(
                              child: Text(productViewModel.searchList[index].title!,),
                            ),

                            Obx(()=> productViewModel.cartList.contains(productViewModel.searchList[index])
                                ?
                            ElevatedButton(
                                onPressed: (){
                                  productViewModel.removeFromCart(productViewModel.searchList[index]);
                                },
                                child: Text("Remove from cart")
                            )
                                :
                            ElevatedButton(
                                onPressed: (){
                                  productViewModel.addToCart(productViewModel.searchList[index]);
                                },
                                child: Text("Add to cart")
                            ))

                          ],
                        );
                      }
                  ),
                ),

              ],
            )
          )
      )
    );
  }
}
