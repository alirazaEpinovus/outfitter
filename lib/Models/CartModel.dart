import 'dart:convert';

CartModel clientFromJson(String str) {
  final jsonData = json.decode(str);
  return CartModel.fromJson(jsonData);
}

String clientToJson(CartModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CartModel {
  int orderId;
  String productName;
  String productColor;
  String productSize;
  String varientId;
  int quantity;
  int price;
  String value;
  String productId;
  String productImage;
  String graphql;
  String available;

  CartModel(
      {this.orderId,
      this.productId,
      this.productName,
      this.productColor,
      this.productSize,
      this.varientId,
      this.value,
      this.quantity,
      this.price,
      this.productImage,
      this.graphql,
      this.available});

  factory CartModel.fromJson(Map<String, dynamic> json) => new CartModel(
        orderId: json["order_id"],
        productId: json["p_id"],
        productName: json["p_name"],
        productColor: json["p_color"],
        productSize: json["p_size"],
        varientId: json["varient_id"],
        quantity: json["quantity"],
        price: json["price"],
        productImage: json['p_image'],
        graphql: json['graphid'],
        value: json['p_value'],
        available: json['available'],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_id": productId,
        "product_name": productName,
        "product_color": productColor,
        "product_size": productSize,
        "varient_id": varientId,
        "quantity": quantity,
        "p_value": value,
        "price": price,
        "product_image": productImage,
        "graphid": graphql,
        "available": available,
      };

  set priceData(int _price) {
    price = _price;
  }
}
