class ProductSize{
  String id;
  String name;


  bool selected = false;

  ProductSize.fromJson(Map<String,dynamic> map,{bool selected:false}):selected= selected,id = map['size_id'],name = map['size'];
}