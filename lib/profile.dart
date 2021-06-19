import 'package:chinakigali/authentication.dart';
import 'package:chinakigali/super_base.dart';
import 'package:chinakigali/wish_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'json/user.dart';
import 'orders.dart';

class Profile extends StatefulWidget {
  final User? user;

  const Profile({Key? key, this.user}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with Superbase {
  bool logged = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My profile",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(icon: Icon(Icons.settings_rounded), onPressed: () {}),
          ],
        ),
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/boys.jpg"),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                              "${widget.user?.firstName} ${widget.user?.lastName}"),
                          subtitle: Text("${widget.user?.phone}"),
                          trailing: Icon(Icons.chevron_right_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Wishlist()));
                        },
                        leading: Icon(Icons.favorite_rounded),
                        title: Text("My wish list"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Orders()));
                        },
                        leading: Icon(Icons.bookmark_rounded),
                        title: Text("Orders"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.help_rounded),
                        title: Text("Help"),
                      ),
                      ListTile(
                        leading: Icon(Icons.share_rounded),
                        title: Text("Invite a friend"),
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Sign Out"),
                                  content: Text("Are you sure ?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel")),
                                    TextButton(
                                        onPressed: () async {
                                          (await prefs).clear();
                                          Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                          Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      Authentication()));
                                        },
                                        child: Text("OK")),
                                  ],
                                );
                              },
                              context: context);
                        },
                        leading: Icon(Icons.exit_to_app_rounded),
                        title: Text("Exit"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
