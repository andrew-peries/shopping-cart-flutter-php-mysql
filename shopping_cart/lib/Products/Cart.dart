import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart/Products/Products.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List cartList = List();
  double subtotal = 0;

  Future fetchCart() async {
    var response = await http
        .get("http://192.168.1.100/shopping_cart_backend/Services/getCart.php");
    if (response.statusCode == 200) {
      setState(() {
        cartList = json.decode(response.body);
        for (int i = 0; i < cartList.length; i++) {
          var a = cartList[i]['num_items'];
          int numberofitems = int.parse(a);
          var b = cartList[i]['price'];
          int price = int.parse(b);
          int tot = numberofitems * price;
          subtotal = subtotal + tot;
        }
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
    fetchCart();
  }

  void deleteData(String _id) async {
    print(_id);
    var url =
        "http://192.168.1.100/shopping_cart_backend/Services/delCartItem.php";
    print(_id);
    var data = {"id": _id};
    var res = await http.post(url, body: data);
    print(res);
  }

  void confirm(String id) {
    print(id);
    AlertDialog alertDialog = new AlertDialog(
      content: Text("Are you sure you want to delete this item?"),
      actions: <Widget>[
        new RaisedButton(
          child: Text(
            "Delete",
            style: new TextStyle(color: Colors.red),
          ),
          color: Colors.white,
          onPressed: () {
            deleteData(id);
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new Cart(),
              ),
            );
          },
        ),
        new RaisedButton(
          child: Text(
            "Cancel",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 10,
        toolbarHeight: 80,
        title: Center(
          child: new Text(
            "Cart",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 27,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Products();
              }));
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Card(
                elevation: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        var id = cartList[index]['id'];
                        var a = cartList[index]['num_items'];
                        int numberofitems = int.parse(a);
                        var b = cartList[index]['price'];
                        int price = int.parse(b);
                        int total = numberofitems * price;

                        return ListTile(
                          hoverColor: Colors.blueGrey[400],
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
                            child: Text(
                              cartList[index]['iname'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  height: 1.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Rs." + cartList[index]['price'],
                                style: TextStyle(
                                    color: Colors.teal[600],
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Pieces: " + cartList[index]['num_items'],
                                style: TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontSize: 18.0,
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Total: $total.00",
                                      style: TextStyle(
                                        color: Colors.blueGrey[900],
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 25.0,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        confirm(id);
                                      },
                                    ),
                                  ]),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 10,
                                thickness: 1,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
            Text(
              "Sub Total: $subtotal",
              style: TextStyle(
                color: Colors.blueGrey[900],
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              width: 180,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.black,
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {}),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
