import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'super_base.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> with Superbase {
  bool _sending = false;

  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool _obSecure = true;

  var _formKey = new GlobalKey<FormState>();

  void register() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _sending = true;
    });
    this.ajax(
        url: "shop/login",
        method: "POST",
        data: FormData.fromMap({
          "shop_phone": _phoneController.text,
          "shop_password": _passwordController.text
        }),
        onEnd: () {
          setState(() {
            _sending = false;
          });
        },
        onValue: (value, string) async {
          if (value['code'] == 200) {
            //           var user = Shop.fromJson(value['data']);
            (await prefs).setString(userKey, jsonEncode(value['data']));
            Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.pushReplacement(
            //     context,
            //     CupertinoPageRoute(
            //         builder: (context) => HomeScreen(
            //               user: user,
            //             )));
          }
          print(value);
          showSnack(value['message']);
        });
  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              children: <Widget>[
                Image.asset(
                  "assets/icon.png",
                  height: 200,
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (s) => s?.trim().isEmpty == true
                      ? "Phone number is required"
                      : null,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "Your Phone Number",
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(40)),
                      fillColor: Colors.orange.shade200),
                ),
                SizedBox(height: 17),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obSecure,
                  validator: (s) =>
                      s?.trim().isEmpty == true ? "Password is required" : null,
                  decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obSecure = !_obSecure;
                            });
                          },
                          child: Icon(Icons.remove_red_eye_rounded)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(40)),
                      fillColor: Colors.orange.shade200),
                ),
                SizedBox(height: 17),
                _sending
                    ? Center(
                        child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      ))
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(1),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.orange),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)))),
                            onPressed: register,
                            child: Text(
                              "LOGIN",
                              style: TextStyle(color: Colors.white),
                            ))),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //         builder: (context) => Registration()));
                  },
                  child: Text(
                    "Don't have an Account ? Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 2,
                      color: Colors.grey.shade200,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      height: 2,
                      color: Colors.grey.shade200,
                    )),
                  ],
                ),
                SizedBox(height: 17),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.indigo),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)))),
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          // Navigator.pushReplacement(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) => HomeScreen(
                          //               user: null,
                          //             )));
                        },
                        child: Text(
                          "Continue as Guest",
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ),
          ),
        ));
  }
}
