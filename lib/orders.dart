import 'package:chinakigali/json/order.dart';
import 'package:chinakigali/order_details.dart';
import 'package:chinakigali/super_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with Superbase {
  List<Order> _orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((timeStamp) => this.loadItems());
  }

  bool _loading = false;

  void loadItems() async {
    setState(() {
      _loading = true;
    });
    await ajax(
        url: "account/orders?customer_id=${(await findUser)?.id}",
        onValue: (source, url) {
          setState(() {
            if (source is Map && source['data'] != null)
              _orders = (source['data'] as Iterable)
                  .map((e) => Order.fromJson(e))
                  .toList();
          });
        });

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My orders"),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                var order = _orders[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  OrderDetail(order: order)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${fmtNbr(order.total)} RWF",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text("${order.time ?? ""} RWF"),
                          SizedBox(
                            height: 3,
                          ),
                          Text("Order track Id : ${order.trackId}"),
                          // order.notes?.trim().isNotEmpty == true
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(top: 3),
                          //         child: Text("${order.notes}"),
                          //       )
                          //     : SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
