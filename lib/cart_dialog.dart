import 'package:cached_network_image/cached_network_image.dart';
import 'package:chinakigali/json/product.dart';
import 'package:chinakigali/json/product_size.dart';
import 'package:chinakigali/json/production_option.dart';
import 'package:chinakigali/super_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as gt;

import 'json/product_color.dart';

class CartDialog extends StatefulWidget{
  final Product product;
  final Notifier? cartCounter;
  final String? color;
  final String? size;
  final String? option;

  const CartDialog({Key? key,required this.product, this.cartCounter, this.color, this.size, this.option}) : super(key: key);
  @override
  _CartDialogState createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> with Superbase {


  bool adding = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) =>this.loadRelated());
  }



  List<Product> _related = [];
  List<String> images = [];

  List<Colour> productColors = [];
  List<Option> productOptions = [];
  List<ProductSize> productSizes = [];


  void loadRelated() {
    this.ajax(
        url: "product/details?product_id=${widget.product.id}",
        error: (s,v)=>print(s),
        server: false,
        onValue: (source, url) {
          setState(() {
            _related = (source['data']['related_products'] as Iterable)
                .map((e) => Product.fromJson(e))
                .toList();
            images = (source['data']['product_images'] as Iterable?)
                ?.map((e) => '$e')
                .toList() ?? [];
            productColors = (source['data']['product_colors'] as Iterable?)
                ?.map((e) => Colour.fromJson(e,selected: widget.color == e['color_id']))
                .toList() ?? [];
            productOptions = (source['data']['product_options'] as Iterable?)
                ?.map((e) => Option.fromJson(e,selected: widget.option == e['option_id']))
                .toList() ?? [];
            productSizes = (source['data']['product_sizes'] as Iterable?)
                ?.map((e) => ProductSize.fromJson(e,selected: widget.size == e['size_id']))
                .toList() ?? [];
          });
        });
  }

  void addToCart() async {


    var colorWhere = productColors.where((element) => element.selected);
    var sizeWhere = productSizes.where((element) => element.selected);
    var optionWhere = productOptions.where((element) => element.selected);

    if(productSizes.isNotEmpty && sizeWhere.isEmpty){
      gt.Get.snackbar("Error", "Select product size",
          icon: Icon(Icons.info_outlined));
      return;
    }

    if(productColors.isNotEmpty && colorWhere.isEmpty){
      gt.Get.snackbar("Error", "Select product color",
          icon: Icon(Icons.info_outlined));
      return;
    }

    if(productOptions.isNotEmpty && optionWhere.isEmpty){
      gt.Get.snackbar("Error", "Select product option",
          icon: Icon(Icons.info_outlined));
      return;
    }

    String color = "";
    String size = "";
    String option = "";

    if(optionWhere.isNotEmpty){
      option = optionWhere.first.id;
    }

    if(sizeWhere.isNotEmpty){
      size = sizeWhere.first.id;
    }

    if(colorWhere.isNotEmpty){
      color = colorWhere.first.id;
    }

    setState(() {
      adding = true;
    });

    await ajax(
        url:
        "cart/add?token=${await findToken}&product_id=${widget.product.id}&quantity=${widget.product.quantity}&color_id=$color&option_id=$option&size_id=$size",
        onValue: (source, url) {
          print(url);
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          widget.cartCounter?.call(widget.product.quantity, increment: true);
          gt.Get.snackbar("Success", source['message'],
              icon: Icon(Icons.check_circle_rounded));
        });
    setState(() {
      adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = widget.product;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
            constraints: BoxConstraints(
              minWidth: 160
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: CachedNetworkImageProvider("${p.image}"),
                    width: 100,
                  ),
                ),
                Expanded(
                  child: Container(
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
                                      p.quantity--;
                                      setState(() => p = p);
                                    },
                                    child: Icon(
                                      Icons.remove_rounded,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${p.quantity}"),
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
                                      p.quantity++;
                                      setState(() => p = p);
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
                        productColors.isNotEmpty ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Colors",style: Theme.of(context).textTheme.headline6,),
                        ) : SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Wrap(children: productColors.map((e) => Container(
                            margin:
                            EdgeInsets.only(right: 5),
                            child: OutlinedButton(
                              style: e.selected ? ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.grey.shade300)
                              ) : null,
                              onPressed: () {
                                setState(() {
                                  productColors.forEach((element) =>element.selected = false);
                                  e.selected = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                padding: EdgeInsets.all(6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${e.name}".toUpperCase(),style: TextStyle(
                                      color: e.color
                                    ),),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin:
                                      EdgeInsets.only(left: 3),
                                      decoration: BoxDecoration(
                                          color: e.color,
                                          borderRadius: BorderRadius.circular(2)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )).toList(),),
                        ),
                        productSizes.isNotEmpty ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Size",style: Theme.of(context).textTheme.headline6,),
                        ) : SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Wrap(children: productSizes.map((e) => Container(
                            margin:
                            EdgeInsets.only(right: 5),
                            child: OutlinedButton(
                              style: e.selected ? ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.grey.shade300)
                              ) : null,
                              onPressed: () {
                                setState(() {
                                  productSizes.forEach((element) =>element.selected = false);
                                  e.selected = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                padding: EdgeInsets.all(6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${e.name}".toUpperCase(),style: TextStyle(
                                    ),),
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
                          )).toList(),),
                        ),
                        productOptions.isNotEmpty ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Options",style: Theme.of(context).textTheme.headline6,),
                        ) : SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Wrap(children: productOptions.map((e) => Container(
                            margin:
                            EdgeInsets.only(right: 5),
                            child: OutlinedButton(
                              style: e.selected ? ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.grey.shade300)
                              ) : null,
                              onPressed: () {
                                setState(() {
                                  productOptions.forEach((element) =>element.selected = false);
                                  e.selected = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                padding: EdgeInsets.all(6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${e.name}".toUpperCase(),style: TextStyle(
                                    ),),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin:
                                      EdgeInsets.only(left: 3),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            e.image
                                          )
                                        ),
                                          borderRadius: BorderRadius.circular(2)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )).toList(),),
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
                ),
              ],
            )),
      ),
    );
  }
}