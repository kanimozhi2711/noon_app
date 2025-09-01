import 'package:flutter/material.dart';
import 'package:noon_app/AppConfig.dart';

import 'add_product_screen.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<dynamic> products = [];
  List<String> modifiedImageUrl = [];
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    try {
      List<dynamic> fetchedProducts = await ApiService.fetchProducts();
      products = fetchedProducts;
      modifiedImageUrl =
          List<String>.filled(products.length, "", growable: true);
      for (int i = 0; i <= products.length - 1; i++) {
        var productimage = products[i];
        String imgurl = await CreateImagePath(productimage["imageurl"]);
        modifiedImageUrl[i] = imgurl;
      }
      setState(() {});
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
        appBar: AppBar(title: Text("Products")),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          print("Searching for: $value");
                        },
                      ),
                    ),
                    if (searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var product = products[index];
                          //baseurl + CreateImagePath(product("imageurl"));
                          return ListTile(
                            leading: Image.network(modifiedImageUrl[index],
                                width: 50, height: 50, fit: BoxFit.cover),
                            title: Text(product["name"]),
                            subtitle: Text("\$${product["price"]}"),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? productadded = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductScreen()),
            );
            if (productadded == true) {
              loadProducts();
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.amber,
        ));
  }

  Future<String> CreateImagePath(String url) async {
    Uri uri = Uri.parse(url);
    String baseUrl = "${uri.scheme}://${uri.host}:${uri.port}";
    String imagePath = uri.path;
    String baseurl = await AppConfig.getBaseUrl();
    return "$baseurl$imagePath";
  }
}
