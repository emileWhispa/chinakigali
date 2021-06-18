import 'package:chinakigali/authentication.dart';
import 'package:chinakigali/cart.dart';
import 'package:chinakigali/categories.dart';
import 'package:chinakigali/products.dart';
import 'package:chinakigali/super_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import 'json/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
          appBarTheme: AppBarTheme(
              actionsIconTheme: IconThemeData(color: Colors.red),
              textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
              iconTheme: IconThemeData(color: Colors.red),
              backgroundColor: Colors.white)),
      home: MyHomePage(title: 'China kigali'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Superbase {
  int _counter = 0;
  int cartCount = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int selected = 0;

  String? _token;

  cartCounter(d, {bool? increment}) {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((timeStamp) => this.loadToken());
  }

  void loadToken() async {
    _token = await findToken;
    this.ajax(
        url:
            "token?username=chinakigali&key=04dfe1f6e2d25c8073dc7237150f9fb67541186b&token=$_token",
        server: true,
        onValue: (source, url) async {
          _token = source['token'];
          (await prefs).setString("token", _token!);
        });
  }

  var _cartKey = new GlobalKey<CartState>();

  User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          IndexedStack(
            index: selected,
            children: [
              Products(cartCounter: cartCounter),
              Cart(
                key: _cartKey,
              ),
              Categories(cartCounter: cartCounter),
              Center(),
              Center(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          if (i == 4 && _user == null) {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => Authentication()));
            return;
          }
          setState(() {
            selected = i;
            if (i == 1) {
              _cartKey.currentState?.reLoad();
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 2,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Badge(
                  elevation: 0,
                  showBadge: cartCount != 0,
                  badgeContent: Text(
                    "$cartCount",
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(Icons.shopping_cart_rounded)),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_rounded), label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: "Me"),
        ],
      ),
    );
  }
}
