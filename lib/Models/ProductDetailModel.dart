class ProductDetailModel {
  String id;
  String title;
  List<String> tags;
  String description;
  String descriptionHtml;
  String productType;
  String handle;
  String onlineStoreUrl;
  Images images;
  VariantsList variantsList;

  ProductDetailModel(
      {this.id,
      this.title,
      this.tags,
      this.description,
      this.descriptionHtml,
      this.productType,
      this.handle,
      this.onlineStoreUrl,
      this.images,
      this.variantsList});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tags = json['tags'].cast<String>();
    description = json['description'];
    handle = json['handle'];
    descriptionHtml = json['descriptionHtml'];
    productType = json['productType'];
    onlineStoreUrl =
        json['onlineStoreUrl'] == null ? '' : json['onlineStoreUrl'];
    images =
        json['images'] != null ? new Images.fromJson(json['images']) : null;
    variantsList = json['variants'] != null
        ? new VariantsList.fromJson(json['variants'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['tags'] = this.tags;
    data['description'] = this.description;
    data['descriptionHtml'] = this.descriptionHtml;
    data['productType'] = this.productType;
    data['handle'] = this.handle;
    data['onlineStoreUrl'] = this.onlineStoreUrl;
    if (this.images != null) {
      data['images'] = this.images.toJson();
    }
    if (this.variantsList != null) {
      data['variants'] = this.variantsList.toJson();
    }
    return data;
  }
}

class Images {
  List<Imageedges> imageedges;

  Images({this.imageedges});

  Images.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      imageedges = new List<Imageedges>();
      json['edges'].forEach((v) {
        imageedges.add(new Imageedges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imageedges != null) {
      data['edges'] = this.imageedges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Imageedges {
  Img img;

  Imageedges({this.img});

  Imageedges.fromJson(Map<String, dynamic> json) {
    img = json['node'] != null ? new Img.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.img != null) {
      data['node'] = this.img.toJson();
    }
    return data;
  }
}

class Img {
  String src;

  Img({this.src});

  Img.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    return data;
  }
}

class VariantsList {
  List<Variantedges> variantedges;

  VariantsList({this.variantedges});

  VariantsList.fromJson(Map<String, dynamic> json) {
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
  String id;
  String price;
  String title;
  bool availableForSale;
  String compareAtPrice;
  Img image;
  String sku;
  bool available;
  List<SelectedOptions> selectedOptions;

  Variantnode(
      {this.id,
      this.price,
      this.title,
      this.availableForSale,
      this.compareAtPrice,
      this.image,
      this.sku,
      this.available,
      this.selectedOptions});

  Variantnode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    title = json['title'];
    availableForSale = json['availableForSale'];
    compareAtPrice = json['compareAtPrice'];
    image = json['image'] != null ? new Img.fromJson(json['image']) : null;
    sku = json['sku'];
    available = json['available'];
    if (json['selectedOptions'] != null) {
      selectedOptions = new List<SelectedOptions>();
      json['selectedOptions'].forEach((v) {
        selectedOptions.add(new SelectedOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['title'] = this.title;
    data['availableForSale'] = this.availableForSale;
    data['compareAtPrice'] = this.compareAtPrice;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['sku'] = this.sku;
    data['available'] = this.available;
    if (this.selectedOptions != null) {
      data['selectedOptions'] =
          this.selectedOptions.map((v) => v.toJson()).toList();
    }
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
