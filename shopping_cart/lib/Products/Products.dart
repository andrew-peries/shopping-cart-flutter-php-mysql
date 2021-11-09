import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Cart.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List productList = List();
  bool isEnabled = true;
  List<int> count;
  Future fetchProducts() async {
    var response = await http.get(
        "http://192.168.1.100/shopping_cart_backend/Services/getProducts.php");
    if (response.statusCode == 200) {
      setState(() {
        productList = json.decode(response.body);
        count = new List.filled(productList.length, 0);
      });
      print("data retieived!");
    } else {
      print("fetching data failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
  }

  Future addtocart(String name, var price, var count) async {
    var data = {
      "iname": name.toString(),
      "price": price.toString(),
      "num_items": count.toString(),
    };
    var response = await http.post(
        "http://192.168.1.100/shopping_cart_backend/Services/addtoCart.php",
        body: data);

    print(name);
  }

  int _n = 0;

  void add(int index) {
    setState(() {
      count[index] = count[index] + 1;
    });
  }

  void minus(int index) {
    setState(() {
      if (count[index] != 0) count[index] = count[index] - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 10,
        toolbarHeight: 80,
        title: Center(
          child: new Text(
            "Products",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart),
              iconSize: 27,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Cart();
                }));
              }),
        ],
      ),
      body: Container(
          child: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          String name = productList[index]['name'];
          var price = productList[index]['price'];

          return Card(
            elevation: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    productList[index]['name'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 27.0,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Price: Rs." + productList[index]['price'] + ".00",
                    style: TextStyle(
                        color: Colors.teal[600],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Available Items: " + productList[index]['item_count'],
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  new Center(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          child: new FloatingActionButton(
                            heroTag: null,
                            onPressed: () => add(index),
                            child: new Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(count[index].toString(),
                            style: new TextStyle(fontSize: 25.0)),
                        SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 30,
                          child: new FloatingActionButton(
                            heroTag: null,
                            onPressed: () => minus(index),
                            child: new Icon(
                                const IconData(0xe15b,
                                    fontFamily: 'MaterialIcons'),
                                color: Colors.white),
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Container(
                        width: screenwidth * 0.3,
                        height: 38,
                        child: productList[index]['item_count'] == '0'
                            ? RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                color: Colors.grey[400],
                                child: Text(
                                  'Unavailable',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onPressed: () {})
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                color: Colors.black,
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onPressed: () {
                                  addtocart(
                                      name, price, count[index].toString());
                                }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}
