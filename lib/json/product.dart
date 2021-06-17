class Product {
  String id;
  String product;
  int? category;
  int amount;
  int? _price;
  int? _bigPrice;
  String image;
  String description;
  int? discountedPrice;

  bool selected = false;
  bool deleting = false;

  Product.fromJson(Map<String, dynamic> json)
      : id = json['product_id'],
        product = json['product_name'],
        amount = int.tryParse(json['amount'] ?? "0") ?? 0,
        description = json['product_description'],
        _price = int.tryParse(json['product_price'] ?? "0.0") ?? 0,
        discountedPrice =
            int.tryParse(json['product_discount_price'] ?? "0.0") ?? 0,
        image = json['product_image'];

  int get price => _price ?? 0;

  int get bigPrice => _bigPrice ?? 0;

  double get save => 100 - (price * 100 / (bigPrice == 0.0 ? 1 : bigPrice));

  Map<String, dynamic> toJson() => {
        "product_id": id,
        "product": product,
        "main_category": category,
        "price": "$_price",
        "list_price": "$_bigPrice",
        "main_pair": {
          "detailed": {"image_path": image}
        }
      };
}

class CartItem {
  String cartId;
  ProductCart productCart;

  CartItem({required this.cartId, required this.productCart});

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
      cartId: json['cart_id'],
      productCart: ProductCart.fromJson(json['product']));
}

class ProductCart {
  String? productId;
  String? thumb;
  String? name;
  String? model;
  String quantity;
  bool? stock;
  String? price;
  String total;

  ProductCart({
    this.productId,
    this.model,
    required this.quantity,
    this.stock,
    this.name,
    required this.total,
    this.thumb,
    this.price,
  });
  factory ProductCart.fromJson(Map<String, dynamic> json) => ProductCart(
      price: "${json['price']}",
      productId: json['product_id'],
      thumb: json['thumb'],
      name: json['name'],
      model: json['model'],
      quantity: json['quantity'],
      stock: json['stock'],
      total: "${json['total']}");

  int get totalQuantity => int.tryParse(quantity) ?? 0;
}
