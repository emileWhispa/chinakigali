import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chinakigali/json/slide.dart';
import 'package:chinakigali/product_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'json/category.dart';
import 'json/product.dart';
import 'super_base.dart';

typedef Notifier = Function(int count, {bool increment});

class Products extends StatefulWidget {
  final Notifier cartCounter;

  const Products({Key? key, required this.cartCounter}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> with Superbase {
  bool loadingProducts = false;
  bool loadingSpecialProducts = false;
  bool loadingBestSellingProducts = false;
  bool loadingNewArrivals = false;
  List<Product> productsList = [];
  List<Product> specialProductsList = [];
  List<Product> bestSellingList = [];
  List<Product> newArrivalsList = [];

  bool loadingCategories = true;
  List<Category> categoriesList = [];
  List<Slide> slides = [];

  String? _token;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getProducts();
      getSlide();
      getCategories();
    });

    super.initState();
  }

  getSlide() {
    this.ajax(
        url: "slides",
        onValue: (object, url) {
          setState(() {
            slides = (object['data'] as Iterable)
                .map((e) => Slide.fromJson(e))
                .toList();
          });
        },
        onEnd: () {
          setState(() {
            loadingCategories = false;
          });
        });
  }

  getCategories() async {
    setState(() {
      loadingCategories = true;
    });

    this.ajax(
        url: "categories",
        onValue: (object, url) {
          setState(() {
            loadingCategories = false;
            categoriesList = (object['data'] as Iterable)
                .map((e) => Category.fromJson(e))
                .toList();
          });
        },
        onEnd: () {
          setState(() {
            loadingCategories = false;
          });
        });
  }

////////////////////
  getProducts() async {
    setState(() {
      loadingProducts = true;
      loadingNewArrivals = true;
      loadingSpecialProducts = true;
      loadingBestSellingProducts = true;
    });

    this.ajax(
        url: "products/featured?limit=6",
        server: false,
        onValue: (object, url) {
          setState(() {
            loadingProducts = false;
            productsList = (object['data'] as Iterable)
                .map((e) => Product.fromJson(e))
                .toList();
          });
        },
        onEnd: () {
          setState(() {
            loadingProducts = false;
          });
        });

    this.ajax(
        url: "products/newarrivals?limit=6",
        server: false,
        onValue: (object, url) {
          setState(() {
            loadingNewArrivals = false;
            newArrivalsList = (object['data'] as Iterable)
                .map((e) => Product.fromJson(e))
                .toList();
          });
        },
        onEnd: () {
          setState(() {
            loadingNewArrivals = false;
          });
        });

    this.ajax(
        url: "products/specials?limit=6",
        server: false,
        onValue: (object, url) {
          setState(() {
            loadingSpecialProducts = false;
            specialProductsList = (object['data'] as Iterable)
                .map((e) => Product.fromJson(e))
                .toList();
          });
        },
        onEnd: () {
          setState(() {
            loadingSpecialProducts = false;
          });
        });

    this.ajax(
        url: "products/bestseller?limit=6",
        server: false,
        onValue: (object, url) {
          setState(() {
            loadingBestSellingProducts = false;
            bestSellingList = (object['data'] as Iterable)
                .map((e) => Product.fromJson(e))
                .toList();
          });
        },
        onEnd: () {
          setState(() {
            loadingBestSellingProducts = false;
          });
        });
  }

  showAddCart(Product pro) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
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
                              // Container(
                              //   height: 30,
                              //   width: 30,
                              //   child: RawMaterialButton(
                              //     elevation: 0,
                              //     shape: new CircleBorder(),
                              //     onPressed: () {
                              //       Navigator.of(context).pop();
                              //     },
                              //     child: Icon(
                              //       Icons.close_rounded,
                              //       color: Colors.redAccent,
                              //       size: 15,
                              //     ),
                              //   ),
                              // ),
                            ],
                            mainAxisSize: MainAxisSize.max,
                          ),
                          // Padding(
                          //     padding:
                          //         EdgeInsets.only(left: 10, right: 10, top: 5),
                          //     child: Text(
                          //       "Minimum: 1",
                          //       overflow: TextOverflow.ellipsis,
                          //       textAlign: TextAlign.start,
                          //       maxLines: 1,
                          //       style: TextStyle(color: Colors.grey),
                          //     )),
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
                                  "${fmtNbr(p.price)} RWF",
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
                                    child: Text("1"),
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

  void cartCounter(int count, {bool? increment}) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Container(height: 47, child: Image.asset("assets/logo.png")),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
        actions: [
//            IconButton(
//                icon: Icon(Icons.notifications_rounded), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.search_rounded), color: color, onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            child: slides.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text("Please wait...",
                        style: TextStyle(color: Colors.grey)),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    child: CarouselSlider.builder(
                        itemCount: slides.length,
                        itemBuilder: (context, index, i) {
                          return Container(
                            child: Image(
                                image: CachedNetworkImageProvider(
                                    slides[index].image)),
                          );
                        },
                        options: CarouselOptions(autoPlay: true)),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                child: Text(
                  "New arrivals",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 28.0,
                  color: color,
                ),
                onPressed: () {},
              )
            ],
          ),
          loadingNewArrivals
              ? Container(
                  height: 230,
                  alignment: Alignment.center,
                  child: Text("Loading products...",
                      style: TextStyle(color: Colors.grey)),
                )
              : !loadingNewArrivals && newArrivalsList.length == 0
                  ? Container(
                      height: 230,
                      alignment: Alignment.center,
                      child: Text(
                        "Error loading products, try again later",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Container(
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 2.7 / 4),
                          itemCount: newArrivalsList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => ProductDetails(
                                              pro: newArrivalsList[index],
                                              cartCounter: cartCounter)));
                                },
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    "${newArrivalsList[index].image}",
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                          ),
                                          child: Text(
                                            "${newArrivalsList[index].product}",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Text(
                                                "${fmtNbr(newArrivalsList[index].price)} RWF",
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            width: 35,
                                            child: RawMaterialButton(
                                              shape: new CircleBorder(),
                                              onPressed: () {
                                                showAddCart(
                                                    newArrivalsList[index]);
                                              },
                                              child: Icon(
                                                Icons.add_shopping_cart_rounded,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                child: Text(
                  "Special Products",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 28.0,
                  color: color,
                ),
                onPressed: () {},
              )
            ],
          ),
          loadingSpecialProducts
              ? Container(
                  height: 230,
                  alignment: Alignment.center,
                  child: Text("Loading products...",
                      style: TextStyle(color: Colors.grey)),
                )
              : !loadingSpecialProducts && specialProductsList.length == 0
                  ? Container(
                      height: 230,
                      alignment: Alignment.center,
                      child: Text(
                        "Error loading products, try again later",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, childAspectRatio: 2.7 / 4),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  "${specialProductsList[index].image}"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: Text(
                                        "${specialProductsList[index].product}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Text(
                                                "${fmtNbr(specialProductsList[index].price)} RWF",
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Text(
                                                "${fmtNbr(specialProductsList[index].discountedPrice ?? 0)} RWF",
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: color,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 35,
                                        child: RawMaterialButton(
                                          shape: new CircleBorder(),
                                          onPressed: () {
                                            showAddCart(
                                                specialProductsList[index]);
                                          },
                                          child: Icon(
                                            Icons.add_shopping_cart_rounded,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: specialProductsList.length),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                child: Text(
                  "Featured Products",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 28.0,
                  color: color,
                ),
                onPressed: () {},
              )
            ],
          ),
          loadingProducts
              ? Container(
                  height: 230,
                  alignment: Alignment.center,
                  child: Text("Loading products...",
                      style: TextStyle(color: Colors.grey)),
                )
              : !loadingProducts && productsList.length == 0
                  ? Container(
                      height: 230,
                      alignment: Alignment.center,
                      child: Text(
                        "Error loading products, try again later",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, childAspectRatio: 2.7 / 4),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  "${productsList[index].image}"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: Text(
                                        "${productsList[index].product}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Text(
                                            "${fmtNbr(productsList[index].price)} RWF",
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 35,
                                        child: RawMaterialButton(
                                          shape: new CircleBorder(),
                                          onPressed: () {
                                            showAddCart(productsList[index]);
                                          },
                                          child: Icon(
                                            Icons.add_shopping_cart_rounded,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: productsList.length),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                child: Text(
                  "Best Selling Products",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 28.0,
                  color: color,
                ),
                onPressed: () {},
              )
            ],
          ),
          loadingBestSellingProducts
              ? Container(
                  height: 230,
                  alignment: Alignment.center,
                  child: Text("Loading products...",
                      style: TextStyle(color: Colors.grey)),
                )
              : !loadingBestSellingProducts && bestSellingList.length == 0
                  ? Container(
                      height: 230,
                      alignment: Alignment.center,
                      child: Text(
                        "Error loading products, try again later",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, childAspectRatio: 2.7 / 4),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  "${bestSellingList[index].image}"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: Text(
                                        "${bestSellingList[index].product}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Text(
                                            "${fmtNbr(bestSellingList[index].price)} RWF",
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 35,
                                        child: RawMaterialButton(
                                          shape: new CircleBorder(),
                                          onPressed: () {
                                            showAddCart(bestSellingList[index]);
                                          },
                                          child: Icon(
                                            Icons.add_shopping_cart_rounded,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: bestSellingList.length)
        ],
      ),
    );
  }
}
