class ProductModel {
  String title;
  String description;
  Products products;

  ProductModel({this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.products != null) {
      data['products'] = this.products.toJson();
    }
    return data;
  }
}

class Products {
  PageInfo pageInfo;
  List<Productedges> productedges;

  Products({this.pageInfo, this.productedges});

  Products.fromJson(Map<String, dynamic> json) {
    pageInfo = json['pageInfo'] != null
        ? new PageInfo.fromJson(json['pageInfo'])
        : null;
    if (json['edges'] != null) {
      productedges = new List<Productedges>();
      json['edges'].forEach((v) {
        productedges.add(new Productedges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pageInfo != null) {
      data['pageInfo'] = this.pageInfo.toJson();
    }
    if (this.productedges != null) {
      data['Productedges'] = this.productedges.map((v) => v.toJson()).toList();
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

class Productedges {
  String cursor;
  Productnode productnode;

  Productedges({this.cursor, this.productnode});

  Productedges.fromJson(Map<String, dynamic> json) {
    cursor = json['cursor'];
    productnode =
        json['node'] != null ? new Productnode.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cursor'] = this.cursor;
    if (this.productnode != null) {
      data['node'] = this.productnode.toJson();
    }

    return data;
  }
}

class Productnode {
  String title;
  String description;
  String descriptionHtml;
  bool availableForSale;
  String productType;
  String publishedAt;
  String onlineStoreUrl;
  Variants variants;
  List<Option> options;
  Images images;
  String id;
  List<String> tags;

  Productnode(
      {this.title,
      this.description,
      this.descriptionHtml,
      this.productType,
      this.publishedAt,
      this.onlineStoreUrl,
      this.variants,
      this.options,
      this.images,
      this.availableForSale,
      this.id,
      this.tags});

  Productnode.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    descriptionHtml = json['descriptionHtml'];
    productType = json['productType'];
    publishedAt = json['publishedAt'];
    availableForSale = json['availableForSale'];

    tags =
        json['tags'].cast<String>() != null ? json['tags'].cast<String>() : '';

    onlineStoreUrl =
        json['onlineStoreUrl'] != null ? json['onlineStoreUrl'] : null;
    options = json["options"] == null
        ? null
        : List<Option>.from(json["options"].map((x) => Option.fromJson(x)));

    variants = json['variants'] != null
        ? new Variants.fromJson(json['variants'])
        : null;
    images =
        json['images'] != null ? new Images.fromJson(json['images']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;

    data['descriptionHtml'] = this.descriptionHtml;
    data['productType'] = this.productType;
    data['publishedAt'] = this.publishedAt;
    data['onlineStoreUrl'] = this.onlineStoreUrl;
    data['options'] = this.options;
    data['availableForSale'] = this.availableForSale;
    if (this.variants != null) {
      data['variants'] = this.variants.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Option {
  Option({
    this.values,
    this.name,
  });

  List<String> values;
  Name name;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        values: json["values"] == null
            ? null
            : List<String>.from(json["values"].map((x) => x)),
        name: json["name"] == null ? null : nameValues.map[json["name"]],
      );

  Map<String, dynamic> toJson() => {
        "values":
            values == null ? null : List<dynamic>.from(values.map((x) => x)),
        "name": name == null ? null : nameValues.reverse[name],
      };
}

enum Name { COLOR, SIZE, SEASON }

final nameValues =
    EnumValues({"Color": Name.COLOR, "Season": Name.SEASON, "Size": Name.SIZE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class Variants {
  List<Variantedges> variantedges;

  Variants({this.variantedges});

  Variants.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      variantedges = new List<Variantedges>();
      json['edges'].forEach((v) {
        variantedges.add(new Variantedges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.variantedges != null) {
      data['edges'] = this.variantedges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variantedges {
  Variantnode variantnode;

  Variantedges({this.variantnode});

  Variantedges.fromJson(Map<String, dynamic> json) {
    variantnode =
        json['node'] != null ? new Variantnode.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.variantnode != null) {
      data['node'] = this.variantnode.toJson();
    }

    return data;
  }
}

class Variantnode {
  Image image;
  String price;
  String id;
  String sku;
  String compareAtPrice;
  bool availableForSale;
  bool available;
  List<SelectedOptions> selectedOptions;

  Variantnode(
      {this.image,
      this.price,
      this.sku,
      this.compareAtPrice,
      this.availableForSale,
      this.selectedOptions,
      this.id,
      this.available});

  Variantnode.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    price = json['price'];
    sku = json['sku'];
    id = json['id'];
    available = json['available'];
    compareAtPrice = json['compareAtPrice'];
    availableForSale = json['availableForSale'];
    if (json['selectedOptions'] != null) {
      selectedOptions = new List<SelectedOptions>();
      json['selectedOptions'].forEach((v) {
        selectedOptions.add(new SelectedOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['price'] = this.price;
    data['sku'] = this.sku;
    data['available'] = this.available;
    data['id'] = this.id;
    data['compareAtPrice'] = this.compareAtPrice;
    data['availableForSale'] = this.availableForSale;
    if (this.selectedOptions != null) {
      data['selectedOptions'] =
          this.selectedOptions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Image {
  String src;
  String altText;

  Image({this.src, this.altText});

  Image.fromJson(Map<String, dynamic> json) {
    src = json['src'];
    altText = json['altText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    data['altText'] = this.altText;

    return data;
  }
}

class SelectedOptions {
  String name;
  String value;

  SelectedOptions({this.name, this.value});

  SelectedOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class Images {
  List<Imagesedges> imagesedges;

  Images({this.imagesedges});

  Images.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      imagesedges = new List<Imagesedges>();
      json['edges'].forEach((v) {
        imagesedges.add(new Imagesedges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imagesedges != null) {
      data['edges'] = this.imagesedges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Imagesedges {
  Image imagesnode;

  Imagesedges({this.imagesnode});

  Imagesedges.fromJson(Map<String, dynamic> json) {
    imagesnode = json['node'] != null ? new Image.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imagesnode != null) {
      data['node'] = this.imagesnode.toJson();
    }

    return data;
  }
}
