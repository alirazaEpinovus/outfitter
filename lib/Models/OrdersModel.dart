class GetOrderModel {
  Customer customer;

  GetOrderModel({this.customer});

  GetOrderModel.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  Orders orders;
  String displayName;

  Customer({this.orders, this.displayName});

  Customer.fromJson(Map<String, dynamic> json) {
    orders =
        json['orders'] != null ? new Orders.fromJson(json['orders']) : null;
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders.toJson();
    }
    data['displayName'] = this.displayName;
    return data;
  }
}

class Orders {
  PageInfo pageInfo;
  List<Edges> edges;

  Orders({this.pageInfo, this.edges});

  Orders.fromJson(Map<String, dynamic> json) {
    pageInfo = json['pageInfo'] != null
        ? new PageInfo.fromJson(json['pageInfo'])
        : null;
    if (json['edges'] != null) {
      edges = new List<Edges>();
      json['edges'].forEach((v) {
        edges.add(new Edges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pageInfo != null) {
      data['pageInfo'] = this.pageInfo.toJson();
    }
    if (this.edges != null) {
      data['edges'] = this.edges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageInfo {
  bool hasNextPage;
  bool hasPreviousPage;

  PageInfo({this.hasNextPage, this.hasPreviousPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasNextPage'] = this.hasNextPage;
    data['hasPreviousPage'] = this.hasPreviousPage;
    return data;
  }
}

class Edges {
  String cursor;
  Node node;

  Edges({this.cursor, this.node});

  Edges.fromJson(Map<String, dynamic> json) {
    cursor = json['cursor'];
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cursor'] = this.cursor;
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    return data;
  }
}

class Node {
  LineItems lineItems;
  String totalPrice;
  String id;
  int orderNumber;
  String totalShippingPrice;
  String subtotalPrice;
  ShippingAddress shippingAddress;

  Node(
      {this.lineItems,
      this.totalPrice,
      this.id,
      this.orderNumber,
      this.totalShippingPrice,
      this.subtotalPrice,
      this.shippingAddress});

  Node.fromJson(Map<String, dynamic> json) {
    lineItems = json['lineItems'] != null
        ? new LineItems.fromJson(json['lineItems'])
        : null;
    totalPrice = json['totalPrice'];
    id = json['id'];
    orderNumber = json['orderNumber'];
    totalShippingPrice = json['totalShippingPrice'];
    subtotalPrice = json['subtotalPrice'];
      shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lineItems != null) {
      data['lineItems'] = this.lineItems.toJson();
    }
    data['totalPrice'] = this.totalPrice;
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['totalShippingPrice'] = this.totalShippingPrice;
    data['subtotalPrice'] = this.subtotalPrice;
    return data;
  }
}

class LineItems {
  List<EdgesLineItem> edges;

  LineItems({this.edges});

  LineItems.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      edges = new List<EdgesLineItem>();
      json['edges'].forEach((v) {
        edges.add(new EdgesLineItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.edges != null) {
      data['edges'] = this.edges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EdgesLineItem {
  NodeLineItem node;

  EdgesLineItem({this.node});

  EdgesLineItem.fromJson(Map<String, dynamic> json) {
    node =
        json['node'] != null ? new NodeLineItem.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    return data;
  }
}

class NodeLineItem {
  int quantity;
  String title;
  Variant variant;

  NodeLineItem({this.quantity, this.title, this.variant});

  NodeLineItem.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    title = json['title'];
    variant =
        json['variant'] != null ? new Variant.fromJson(json['variant']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['title'] = this.title;
    if (this.variant != null) {
      data['variant'] = this.variant.toJson();
    }
    return data;
  }
}

class Variant {
  ImageItem image;
  String price;
  Product product;

  Variant({this.image, this.price, this.product});

  Variant.fromJson(Map<String, dynamic> json) {
    image =
        json['image'] != null ? new ImageItem.fromJson(json['image']) : null;
    price = json['price'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['price'] = this.price;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class ImageItem {
  String src;

  ImageItem({this.src});

  ImageItem.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    return data;
  }
}

class Product {
  String title;
  String createdAt;

  Product({this.title, this.createdAt});

  Product.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
class ShippingAddress {
  String address1;
  String address2;

  ShippingAddress({this.address1, this.address2});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    return data;
  }
}