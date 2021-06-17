import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'json/product.dart';

typedef Notifier = Function(int count, {bool increment});

class ProductDetails extends StatefulWidget {
  final Product pro;
  final Notifier cartCounter;

  ProductDetails({
    required this.pro,
    required this.cartCounter,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? token;

  List feedbacks = [];

  @override
  void initState() {
    super.initState();
  }

  showAddCart(Product pro) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          Product p = pro;
          var price = pro.price;

          bool adding = false;

          return StatefulBuilder(builder: (context, newState) {
            addToCart() async {
              print("Adding.....");
              newState(() {
                adding = true;
              });
              try {
                var dio = Dio();

                newState(() {
                  adding = false;
                });
              } on DioError catch (e) {
                newState(() {
                  adding = false;
                });
                print(e);
              }
            }

            return Container(
                height: 160,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image(
                      image: CachedNetworkImageProvider("${p.image}"),
                      width: 100,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 110,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Text("${p.product}",
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: RawMaterialButton(
                                  elevation: 0,
                                  shape: new CircleBorder(),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.redAccent,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                            mainAxisSize: MainAxisSize.max,
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 5),
                              child: Text(
                                "Minimum: 1",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: TextStyle(color: Colors.grey),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: EdgeInsets.all(7),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Text(
                                  "${p.price} RWF",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: RawMaterialButton(
                                      elevation: 0,
                                      shape: new CircleBorder(),
                                      fillColor: Theme.of(context).accentColor,
                                      onPressed: () {
                                        newState(() => p = p);
                                      },
                                      child: Icon(
                                        Icons.remove_rounded,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("0"),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 7),
                                    child: RawMaterialButton(
                                      elevation: 0,
                                      shape: new CircleBorder(),
                                      fillColor: Theme.of(context).accentColor,
                                      onPressed: () {
                                        newState(() => p = p);
                                      },
                                      child: Icon(
                                        Icons.add_rounded,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 10),
                            child: RaisedButton.icon(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              onPressed: adding
                                  ? null
                                  : () {
                                      addToCart();
                                      // Navigator.of(context).pop();
                                    },
                              icon: adding
                                  ? Icon(
                                      Icons.close_rounded,
                                      color: Colors.transparent,
                                    )
                                  : Icon(Icons.add_shopping_cart_rounded),
                              label: adding
                                  ? SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text("Add  to cart"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Theme.of(context).cardColor,
                    title: Text(
                      "Product details",
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.more_vert_rounded),
                          onPressed: () {}),
                    ],
                  ),
                  SliverToBoxAdapter(
                      child: SizedBox(
                    height: 10,
                  )),
                  SliverToBoxAdapter(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 180.0,
                        autoPlay: true,
                      ),
                      items: [widget.pro.image].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                ),
                                child: Image(
                                  image: CachedNetworkImageProvider(i),
                                  fit: BoxFit.cover,
                                ));
                          },
                        );
                      }).toList(),
                    ),
                  ),
//          SliverToBoxAdapter(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Padding(
//                  padding:
//                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
//                  child: Text(
//                    "Categories",
//                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                  ),
//                ),
//                IconButton(
//                  splashColor: Config.secondaryColor,
//                  icon: Icon(
//                    Icons.chevron_right,
//                    size: 28.0,
//                    color: Config.primaryColor,
//                  ),
//                  onPressed: () {},
//                )
//              ],
//            ),
//          ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 5),
                          child: Text(
                            "${widget.pro.price} RWF",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        IconButton(
                          splashColor: Theme.of(context).accentColor,
                          icon: Icon(
                            Icons.favorite_outline_rounded,
                            size: 28.0,
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Card(
                      elevation: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 5),
                            child: Text(
                              "${widget.pro.description == ".." ? "There is no description for this product" : widget.pro.description}",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 5),
                                child: Text(
                                  "0 Orders",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 13.0,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    size: 13.0,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    size: 13.0,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Card(
                      elevation: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              "Shipping",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              "Estimated time of delivery is unknown",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 5),
                            child: Text(
                              "We usually ship within 4 working days",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Card(
                      elevation: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 2),
                            child: Text(
                              "Feedback (0)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          feedbacks.length == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 300,
                                  child: Text(
                                    "There are no feedback on this product yet.",
                                    style: TextStyle(color: Colors.grey),
                                  ))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 12,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          dense: true,
                                          leading: CircleAvatar(
                                            child: Icon(Icons.person_rounded),
                                          ),
                                          title: Text("Customer name"),
                                          subtitle: Text("12 Oct 2020 12:23"),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                size: 13.0,
                                              ),
                                              Icon(
                                                Icons.star_rounded,
                                                size: 13.0,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              left: 10,
                                              right: 10,
                                              bottom: 5),
                                          child: Text(
                                            "This is my feedback, it was good product and i loved it, keep up the good work",
                                          ),
                                        ),
                                        Divider(
                                          indent: 10,
                                          endIndent: 10,
                                        )
                                      ],
                                    );
                                  })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    child: RaisedButton.icon(
                      elevation: 0,
                      onPressed: () {
                        showAddCart(widget.pro);
                      },
                      textColor: Colors.white,
                      icon: Icon(Icons.add_shopping_cart_rounded),
                      label: Text("Add to cart"),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                    onPressed: () {},
                    textColor: Colors.white,
                    icon: Icon(Icons.share_rounded),
                    label: Text("Share"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
