class Order {
  String id;
  String customerId;
  String methodId;
  String trackId;
  int total;
  String? notes;
  String? time;

  Order.fromJson(Map<String, dynamic> map)
      : id = map['order_id'],
        methodId = map['payment_method_id'],
        trackId = map['order_track_id'],
        total = int.tryParse("${map['order_total']}") ?? 0,
        notes = map['order_notes'],
        time = map['order_time'],
        customerId = map['customer_id'];
}
