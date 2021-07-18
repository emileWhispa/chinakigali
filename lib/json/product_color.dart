import 'dart:ui';

import 'package:chinakigali/super_base.dart';

class Colour {
  String id;
  String name;
  String code;
  Color? color;
  bool selected = false;

  Colour.fromJson(Map<String, dynamic> map,{bool selected:false})
      : id = map['color_id'] ?? "",
        name = map['color_name'] ?? "",
  selected = selected,
  color = HexColor.fromHex(map['color_code'] ?? ""),
        code = map['color_code'] ?? "";
}
