import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class Superbase {
  String get bigBase => "https://chinakigali.com/api/";

  String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBjcGFpLnRlY2giLCJleHAiOjE2MDEyMTIzODF9.Lw8Acj_ldP4AakcucN3zKM7I1kTEqKTQc70VdfTga827oz1afKP9Gv54veYBVE0a4PEwN7jPt0xqefV_VsIMyg";

  String get server => "$bigBase";

//  String server = "https://licensing.rura.rw/api/v1/";

  String userKey = "user-key-val";

  Color color = Color(0xffe62e04);

  List<MaterialColor> get colors =>
      Colors.primaries.where((element) => element != Colors.yellow).toList();

  String url(String url) => "$server$url";

  Future<void> save(String key, dynamic val) {
    return saveVal(key, jsonEncode(val));
  }

  var platform = MethodChannel('app.channel.shared.data');

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  Future<void> saveVal(String key, String value) async {
    (await prefs).setString(key, value);
    return Future.value();
  }

  String fmt(String test) {
    return test.replaceAllMapped(reg, (Match match) => '${match[1]},');
  }

  String fmtNbr(num test) {
    return fmt(test.toString());
  }

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  bool canDecode(String jsonString) {
    var decodeSucceeded = false;
    try {
      json.decode(jsonString);
      decodeSucceeded = true;
    } on FormatException {}
    return decodeSucceeded;
  }

  Future<void> ajax(
      {required String url,
      String method: "GET",
      FormData? data,
      Map<String, dynamic>? map,
      bool server: true,
      bool auth: true,
      bool local: false,
      bool base2: false,
      String? authKey,
      bool json: true,
      bool absolutePath: false,
      ResponseType responseType: ResponseType.json,
      bool localSave: false,
      String? jsonData,
      void Function(dynamic response, String url)? onValue,
      void Function()? onEnd,
      void Function(dynamic response, String url)? error}) async {
    url = absolutePath ? url : this.url(url);

    Map<String, String> headers = new Map<String, String>();

    var prf = await prefs;
    if (auth && authKey != null) {
      headers['token'] = '$authKey';
    }

    Options opt = Options(
        responseType: responseType,
        headers: headers,
        receiveDataWhenStatusError: true,
        sendTimeout: 30000,
        receiveTimeout: 30000);

    if (!server) {
      String? val = prf.getString(url);
      bool t = onValue != null && val != null;
      local = local && t;
      localSave = localSave && t;
      var c = (t && json && canDecode(val)) || !json;
      t = t && c;
      if (t) onValue(json ? jsonDecode(val) : val, url);
    }

    if (local) {
      if (onEnd != null) onEnd();
      return Future.value();
    }

    Future<Response> future = method.toUpperCase() == "POST"
        ? Dio().post(url, data: jsonData ?? map ?? data, options: opt)
        : method.toUpperCase() == "PUT"
            ? Dio().put(url, data: jsonData ?? map ?? data, options: opt)
            : method.toUpperCase() == "DELETE"
                ? Dio().delete(url, data: jsonData ?? map ?? data, options: opt)
                : Dio().get(url, options: opt);

    try {
      Response response = await future;
      dynamic data = response.data;
      if (response.statusCode == 200) {
        //var cond = (data is String && json && canDecode(data)) || !json;
        if (!server) this.saveVal(url, jsonEncode(data));

        if (onValue != null && !localSave)
          onValue(data, url);
        else if (error != null) error(data, url);
      } else if (error != null) {
        error(data, url);
      }
    } on DioError catch (e) {
      //if (e.response != null) {
      var resp = e.response != null ? e.response!.data : e.message;
      if (error != null) error(resp, url);
      //}
    }

    if (onEnd != null) onEnd();
    return Future.value();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
