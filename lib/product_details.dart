import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'json/product.dart';
import 'json/product_color.dart';
import 'json/product_size.dart';
import 'json/production_option.dart';
import 'product_item.dart';
import 'super_base.dart';

class ProductDetails extends StatefulWidget {
  final Product pro;
  final Notifier? cartCounter;

  ProductDetails({
    required this.pro,
    this.cartCounter,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> with Superbase {
  String? _token;

  List feedbacks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      this.loadRelated();
    });
  }

  List<Product> _related = [];
  List<String> images = [];

  List<Colour> productColors = [];
  List<Option> productOptions = [];
  List<ProductSize> productSizes = [];

  String? colour;
  String? size;
  String? option;

  void loadRelated() {
    this.ajax(
        url: "product/details?product_id=${widget.pro.id}",
        error: (s, v) => print(s),
        server: false,
        onValue: (source, url) {
          setState(() {
            _related = (source['data']['related_products'] as Iterable)
                .map((e) => Product.fromJson(e))
                .toList();
            images = (source['data']['product_images'] as Iterable?)
                    ?.map((e) => '$e')
                    .toList() ??
                [];
            productColors = (source['data']['product_colors'] as Iterable?)
                    ?.map((e) => Colour.fromJson(e))
                    .toList() ??
                [];
            productOptions = (source['data']['product_options'] as Iterable?)
                    ?.map((e) => Option.fromJson(e))
                    .toList() ??
                [];
            productSizes = (source['data']['product_sizes'] as Iterable?)
                    ?.map((e) => ProductSize.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  bool _processingWishList = false;

  bool _favorite = false;

  void addToWishList() async {
    setState(() {
      _processingWishList = true;
    });
    await ajax(
        url:
            "wishlist/${_favorite ? "delete" : "add"}?token=${await findToken}&product_id=${widget.pro.id}&customer_id=${(await findUser)?.id}",
        onValue: (s, v) {
          print(s);
          Get.snackbar("Success", s['message']);
        });
    setState(() {
      _processingWishList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.pro.product}",
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ],
        ),
      ),
      body: Material(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 10,
                    )),
                    SliverToBoxAdapter(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 230.0,
                        ),
                        items: (images.isNotEmpty ? images : [widget.pro.image])
                            .map((i) {
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
                              "${fmtNbr(widget.pro.price)} RWF",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          IconButton(
                            splashColor: Theme.of(context).accentColor,
                            icon: _processingWishList
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ))
                                : Icon(
                                    Icons.favorite_outline_rounded,
                                    size: 28.0,
                                    color: color,
                                  ),
                            onPressed:
                                _processingWishList ? null : addToWishList,
                          )
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Card(
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
                            productColors.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Colors",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Wrap(
                                children: productColors
                                    .map((e) => Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: OutlinedButton(
                                            style: e.selected
                                                ? ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .grey.shade300))
                                                : null,
                                            onPressed: () {
                                              setState(() {
                                                colour = e.id;
                                                productColors.forEach(
                                                    (element) => element
                                                        .selected = false);
                                                e.selected = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              padding: EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${e.name}".toUpperCase(),
                                                    style: TextStyle(
                                                        color: e.color),
                                                  ),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    decoration: BoxDecoration(
                                                        color: e.color,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            productSizes.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Size",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Wrap(
                                children: productSizes
                                    .map((e) => Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: OutlinedButton(
                                            style: e.selected
                                                ? ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .grey.shade300))
                                                : null,
                                            onPressed: () {
                                              setState(() {
                                                size = e.id;
                                                productSizes.forEach(
                                                    (element) => element
                                                        .selected = false);
                                                e.selected = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              padding: EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${e.name}".toUpperCase(),
                                                    style: TextStyle(),
                                                  ),
                                                  // Container(
                                                  //   width: 20,
                                                  //   height: 20,
                                                  //   margin:
                                                  //   EdgeInsets.only(left: 3),
                                                  //   decoration: BoxDecoration(
                                                  //     image: DecorationImage(
                                                  //       image: CachedNetworkImageProvider(
                                                  //         e.image
                                                  //       )
                                                  //     ),
                                                  //       borderRadius: BorderRadius.circular(2)
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            productOptions.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Options",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Wrap(
                                children: productOptions
                                    .map((e) => Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: OutlinedButton(
                                            style: e.selected
                                                ? ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .grey.shade300))
                                                : null,
                                            onPressed: () {
                                              setState(() {
                                                option = e.id;
                                                productOptions.forEach(
                                                    (element) => element
                                                        .selected = false);
                                                e.selected = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              padding: EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${e.name}".toUpperCase(),
                                                    style: TextStyle(),
                                                  ),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                                    e.image)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 10, right: 10, bottom: 5),
                                  child: Text(
                                    "${++widget.pro.views} Views",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 10, right: 10, bottom: 2),
                              child: Text(
                                "Related products",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Container(
                              child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 2.7 / 4),
                                  itemCount: _related.length,
                                  itemBuilder: (context, index) {
                                    return ProductItem(
                                      product: _related[index],
                                      cartCounter: widget.cartCounter,
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         height: 45,
              //         child: RaisedButton.icon(
              //           color: Theme.of(context).accentColor,
              //           elevation: 0,
              //           onPressed: () {
              //             showAddCart(context, widget.pro);
              //           },
              //           textColor: Colors.white,
              //           icon: Icon(Icons.add_shopping_cart_rounded),
              //           label: Text("Add to cart"),
              //         ),
              //       ),
              //     ),
              //     // Container(
              //     //   height: 45,
              //     //   child: RaisedButton.icon(
              //     //     shape: RoundedRectangleBorder(),
              //     //     elevation: 0,
              //     //     onPressed: () {},
              //     //     textColor: Colors.white,
              //     //     icon: Icon(Icons.share_rounded),
              //     //     label: Text("Share"),
              //     //   ),
              //     // ),
              //   ],
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddCart(context, widget.pro, cartCounter: widget.cartCounter,size: size,color: colour,option: option);
        },
        label: Text("Add To Cart"),
        icon: Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
