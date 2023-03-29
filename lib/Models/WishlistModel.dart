class WishListModel {
  int id;
  String productGraphid;
  String value;
  String productName;
  String productImage;
  int productPrice;
  String isfav;
  String onlineStoreUrl;
  String available;

  WishListModel(
      {this.id,
      this.productGraphid,
      this.productName,
      this.value,
      this.productImage,
      this.productPrice,
      this.isfav,
      this.onlineStoreUrl,
      this.available});

  factory WishListModel.fromJson(Map<String, dynamic> json) =>
      new WishListModel(
        id: json["id"],
        onlineStoreUrl: json['onlineStoreUrl'],
        productGraphid: json['graphid'],
        productName: json["wishproduct_name"],
        productImage: json["wishproduct_image"],
        productPrice: json["wishproduct_price"],
        isfav: json["isFav"],
        value: json['p_value'],
        available: json["available"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "graphid": productGraphid,
        "onlineStoreUrl": onlineStoreUrl,
        "wishproduct_name": productName,
        "wishproduct_image": productImage,
        "wishproduct_price": productPrice,
        "isFav": isfav,
        "p_value": value,
        "available": available,
      };
}
