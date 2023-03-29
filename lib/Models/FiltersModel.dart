class Filterx {
  List<String> colors;
  List<String> fabrics;
  List<String> price;
  List<String> type;
  List<String> shopByProducts;
  List<String> size;

  Filterx(
      {this.colors,
      this.fabrics,
      this.price,
      this.type,
      this.shopByProducts,
      this.size});

  Filterx.fromJson(json) {
    colors = json['colors'].cast<String>();
    fabrics = json['fabrics'].cast<String>();
    price = json['prices'].cast<String>();
    type = json['product_types'].cast<String>();
    shopByProducts = json['shop_by_products'].cast<String>();
    size = json['sizes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colors'] = this.colors;
    data['fabrics'] = this.fabrics;
    data['prices'] = this.price;
    data['product_types'] = this.type;
    data['shop_by_products'] = this.shopByProducts;
    data['sizes'] = this.size;
    return data;
  }
}
