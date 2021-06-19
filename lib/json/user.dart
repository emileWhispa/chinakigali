class User {
  String id;
  String firstName;
  String lastName;
  String company;
  String phone;
  String? email;
  String? street;
  String? address;
  String? address2;
  String? regDate;

  User.fromJson(Map<String, dynamic> map)
      : id = map['customer_id'],
        lastName = map['customer_lname'],
        company = map['customer_company'],
        phone = map['customer_phone'],
        email = map['customer_email'],
        street = map['customer_street'],
        address = map['customer_address'],
        address2 = map['customer_address_2'],
        regDate = map['customer_reg_date'],
        firstName = map['customer_fname'];
}
