class Option {
  String id;
  String name;
  String image;
  int? price;
  bool selected = false;

  Option.fromJson(Map<String, dynamic> map,{bool selected:false})
      : id = map['option_id'],
        name = map['option_name'],
  selected = selected,
        price = int.tryParse(map['option_price']) ?? 0,
        image = map['option_image'];
}
