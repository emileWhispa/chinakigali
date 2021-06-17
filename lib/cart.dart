import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'json/product.dart';
import 'super_base.dart';

typedef Notifier = Function(int count, {bool increment});

class Cart extends StatefulWidget {
  final Notifier? cartCounter;

  const Cart({Key? key, this.cartCounter}) : super(key: key);

  @override
  CartState createState() => CartState();
}

class CartState extends State<Cart> with Superbase {
  bool loadingProducts = false;
  List<CartItem> productsList = [];

  Map<String, dynamic> selectedShipping = Map();
  Map<String, dynamic> selectedPayment = Map();

  String? _token;
  Map<String, dynamic>? addedShipping, addedPayment;
  bool? addedCustomer;

  @override
  void initState() {
    super.initState();
    reLoad();
  } ////////////////////

  void reLoad() {
    getCartProducts(token, server: true);
  }

  getCartProducts(String token, {bool server: false}) async {
    setState(() {
      loadingProducts = true;
    });
    var data1 = {
      "api_token": token,
    };

    this.ajax(
        url: "cart/products",
        method: "POST",
        server: server,
        data: FormData.fromMap(data1),
        onValue: (object, url) {
          print(url);
          setState(() {
            loadingProducts = false;
            if (object['data'] is Map) {
              productsList = (object['data'] as Iterable)
                  .map((e) => CartItem.fromJson(e))
                  .toList();
              var fold = productsList.fold<int>(
                  0,
                  (previousValue, element) =>
                      previousValue + element.productCart.totalQuantity);
            }
          });
        },
        onEnd: () {
          setState(() {
            loadingProducts = false;
          });
        });
  }

  ///////
  createOrder(String code) async {
    showLoading("Creating your order...");

    try {
      var dio = Dio();

      var data = {
        "api_token": token,
      };

      Map<String, dynamic> d = {};

      print("shit");
      print(d);
      if (d["status"] != null && d['status'] == 200) {
        if (code != "cod") {
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Error"),
                  content:
                      Text("Order created , you will pay cash on delivery"),
                  actions: [
                    FlatButton(
                      child: Text("Close"),
                      onPressed: () {},
                    )
                  ],
                );
              });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(
                    "We are not able to create your order because of the following reason \"${d['message']}\""),
                actions: [
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {},
                  )
                ],
              );
            });
      }
    } on DioError catch (e) {
      print(e);
    }
  }

////////////
  removeCart(String cartId) async {
    showLoading("Removing item...");
  }

  modifyCart(String cartId, String quantity) async {
    // showLoading("Removing item...");
  }

  showLoading(msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                kIsWeb
                    ? CircularProgressIndicator()
                    : Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text("$msg"),
              ],
            ),
          );
        });
  }

  Future<void> setAddress(data1, isShipping) async {
    return Future.value();
  }

  showShippings() {}

  showPayments() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            "My Shopping Cart ",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              loadingProducts
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("Loading cart...",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  : !loadingProducts && productsList.length == 0
                      ? Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Your cart is empty, add some items",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: productsList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    elevation: 0,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7))),
                                    child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Image(
                                                image: CachedNetworkImageProvider(
                                                    "${productsList[index].productCart.thumb}"),
                                                width: 100,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    110,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 10),
                                                            child: Text(
                                                                "${productsList[index].productCart.name}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              RawMaterialButton(
                                                            elevation: 0,
                                                            shape:
                                                                new CircleBorder(),
                                                            onPressed: () {
                                                              removeCart(
                                                                  productsList[
                                                                          index]
                                                                      .cartId);
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .close_rounded,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5),
                                                        child: Text(
                                                          "${productsList[index].productCart.price} RWF/Item",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(7),
                                                          margin:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25))),
                                                          child: Text(
                                                            "${productsList[index].productCart.total} RWF",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 30,
                                                              width: 30,
                                                              child:
                                                                  RawMaterialButton(
                                                                elevation: 0,
                                                                shape:
                                                                    new CircleBorder(),
                                                                onPressed: () {
                                                                  CartItem p =
                                                                      productsList[
                                                                          index];

                                                                  int q = int.parse(p
                                                                      .productCart
                                                                      .quantity);
                                                                  p.productCart
                                                                          .quantity =
                                                                      "${q > 1 ? q - 1 : q}";

                                                                  setState(() {
                                                                    productsList[
                                                                        index] = p;
                                                                  });

                                                                  modifyCart(
                                                                      p.cartId,
                                                                      p.productCart
                                                                          .quantity);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .remove_rounded,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  "${productsList[index].productCart.quantity}"),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              width: 30,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 7),
                                                              child:
                                                                  RawMaterialButton(
                                                                elevation: 0,
                                                                shape:
                                                                    new CircleBorder(),
                                                                onPressed: () {
                                                                  CartItem p =
                                                                      productsList[
                                                                          index];

                                                                  int q = int.parse(p
                                                                      .productCart
                                                                      .quantity);
                                                                  p.productCart
                                                                          .quantity =
                                                                      "${q + 1}";

                                                                  setState(() {
                                                                    productsList[
                                                                        index] = p;
                                                                  });
                                                                  modifyCart(
                                                                      p.cartId,
                                                                      p.productCart
                                                                          .quantity);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .add_rounded,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )));
                              }),
                        ),
              productsList.length != 0
                  ? ListTile(
                      dense: true,
                      title: Text("Sub total"),
                      subtitle: Text(
                          "${productsList.fold<double>(0.0, (previousValue, element) => previousValue + int.parse(element.productCart.total))} RWF"),
                      trailing: RaisedButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: Colors.green,
                        onPressed: () async {},
                        textColor: Colors.white,
                        child: Text("Place order"),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
