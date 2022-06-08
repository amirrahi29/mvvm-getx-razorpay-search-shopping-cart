import 'package:flutter_mvvm/model/ProductModel.dart';
import 'package:flutter_mvvm/repositories/ProductRepository.dart';
import 'package:get/get.dart';

class ProductViewModel extends GetxController{

  var productList = <ProductModel>[].obs;
  var searchList = <ProductModel>[].obs;
  var cartList = <ProductModel>[].obs;
  var isLoading = true.obs;

  double get totalPrice => cartList.fold(0, (sum, item) => sum+item.price!);
  int get count => cartList.length;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllProducts();
  }

  void addToCart(ProductModel item){
    cartList.add(item);
  }

  void removeFromCart(ProductModel item){
    cartList.removeWhere((element) => element.id == item.id);
  }

  void clearCart(){
    cartList.clear();
  }

  Future<void> getAllProducts() async{
    var product = await ProductRepository().fetchProducts();
    if(product != null)
      {
        productList.value = product;
        isLoading.value = false;
      }
    else{
      isLoading.value = true;
    }
  }

  void onTextChanged(String text){
    searchList.clear();
    if(text.isEmpty){
      productList.forEach((element) {
        searchList.add(element);
      });
    }
    else{
      productList.forEach((element) {
        if(element.title!.toLowerCase().contains(text))
          {
            searchList.add(element);
          }
      });
    }

  }

}