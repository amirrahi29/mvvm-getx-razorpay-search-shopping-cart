import 'package:flutter_mvvm/model/ProductModel.dart';
import 'package:http/http.dart' as http;
import '../Utils/Constants.dart';

class ProductRepository{

  static var client = http.Client();
  
  Future<List<ProductModel>?> fetchProducts() async{
    var response = await client.get(Uri.parse(BASE_URL));
    if(response.statusCode == 200)
      {
        return productModelFromJson(response.body);
      }
    else
      {
        return null;
      }
  }

}