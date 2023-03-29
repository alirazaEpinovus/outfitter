class Announcement {
  String annouce;
  bool isAnnounce;

  Announcement({this.annouce, this.isAnnounce});
  factory Announcement.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Announcement(
        annouce: parsedJson['announcement_message'],
        isAnnounce: parsedJson['is_announcement']);
  }
}

class Sliders {
  List<SliderDetails> sliders;

  Sliders({this.sliders});

  factory Sliders.fromJSON(Map<dynamic, dynamic> json) {
    return Sliders(sliders: parsecollectionss(json));
  }

  static List<SliderDetails> parsecollectionss(collectionsJSON) {
    var sliderList = collectionsJSON['custom_pages'] as List;

    List<SliderDetails> sliders =
        sliderList.map((data) => SliderDetails.fromJson(data)).toList();
    return sliders;
  }
}

class SliderDetails {
  String bannerImage;
  String qraphQl;
  bool isVideo;
  String name;
  Filters filters;
  String sortOrder;
  bool isFilters;
  List customTags;
  String sortingValue;
  String bannerVideo;

  SliderDetails(
      {this.bannerImage,
      this.qraphQl,
      this.isVideo,
      this.name,
      this.filters,
      this.isFilters,
      this.bannerVideo,
      this.sortingValue,
      this.customTags,
      this.sortOrder});

  factory SliderDetails.fromJson(Map<dynamic, dynamic> parsedJson) {
    return SliderDetails(
        sortingValue: parsedJson['sorting'],
        bannerImage: parsedJson['image_src'],
        bannerVideo: parsedJson['video_src'],
        qraphQl: parsedJson['graphql_id'],
        isVideo: parsedJson['is_video'],
        name: parsedJson['title'],
        isFilters: parsedJson['is_filter'],
        sortOrder: parsedJson['sort_order'],
        filters: parsedJson['filters'] != null
            ? new Filters.fromJson(parsedJson['filters'])
            : null,
        customTags:
            parsedJson['custom_tags'] == null ? [] : parsedJson['custom_tags']);
  }
}

class CollectionsList {
  List<CollectionsDetails> collectionsList;

  CollectionsList({this.collectionsList});

  factory CollectionsList.fromJSON(Map<dynamic, dynamic> json) {
    return CollectionsList(collectionsList: parsecollectionss(json));
  }

  static List<CollectionsDetails> parsecollectionss(collectionsJSON) {
    var list = collectionsJSON['collections'] as List;

    List<CollectionsDetails> collectionsList =
        list.map((data) => CollectionsDetails.fromJSON(data)).toList();
    return collectionsList;
  }
}

class CollectionsDetails {
  String image;
  String name;
  String sortOrder;
  String menuColor;
  List<SubCollections> subCollection;

  CollectionsDetails(
      {this.image,
      this.subCollection,
      this.name,
      this.sortOrder,
      this.menuColor});

  factory CollectionsDetails.fromJSON(Map<dynamic, dynamic> json) {
    return CollectionsDetails(
        subCollection: parsecollectionss(json),
        image: json['image_src'],
        name: json['title'],
        menuColor: json["menu_color"],
        sortOrder: json['sort_order']);
  }

  static List<SubCollections> parsecollectionss(collectionsJSON) {
    var lists = collectionsJSON['sub_collections'] as List;

    List<SubCollections> collectionsDetails = lists != null
        ? lists.map((data) => SubCollections.fromJSON(data)).toList()
        : [];
    return collectionsDetails;
  }
}

class SubCollections {
  String name;
  String shopifyId;
  List<NestedSubCollections> nestedSubCollection;
  Filters filters;
  String sortingValue;
  bool isFilters;
  String sortOrder;
  String menuColor;
  List customTags;

  SubCollections(
      {this.name,
      this.shopifyId,
      this.sortingValue,
      this.nestedSubCollection,
      this.filters,
      this.isFilters,
      this.menuColor,
      this.sortOrder,
      this.customTags});

  factory SubCollections.fromJSON(Map<dynamic, dynamic> json) {
    return SubCollections(
        sortingValue: json['sorting'],
        shopifyId: json['graphql_id'],
        name: json['title'],
        sortOrder: json['sort_order'],
        menuColor: json["menu_color"],
        nestedSubCollection: parsecollectionss(json),
        isFilters: json['is_filter'],
        filters: json['filters'] != null
            ? new Filters.fromJson(json['filters'])
            : null,
        customTags: json['custom_tags'] == null ? [] : json['custom_tags']);
  }

  static List<NestedSubCollections> parsecollectionss(collectionsJSON) {
    var lists = collectionsJSON['third_level_collections'] as List;

    List<NestedSubCollections> collectionsDetails = lists != null
        ? lists.map((data) => NestedSubCollections.fromJson(data)).toList()
        : [];
    return collectionsDetails;
  }
}

class NestedSubCollections {
  String name;
  String shopifyId;
  List<NestedSubCollections2> nestedSubCollection2;
  Filters filters;
  bool isFilters;
  String sortingValue;
  String sortOrder;
  List customTags;
  String menuColor;

  NestedSubCollections(
      {this.name,
      this.shopifyId,
      this.nestedSubCollection2,
      this.sortOrder,
      this.filters,
      this.sortingValue,
      this.customTags,
      this.menuColor,
      this.isFilters});

  factory NestedSubCollections.fromJson(Map<dynamic, dynamic> json) {
    return NestedSubCollections(
        sortingValue: json['sorting'],
        shopifyId: json['graphql_id'],
        name: json['title'],
        sortOrder: json['sort_order'],
        nestedSubCollection2: parsecollections2(json),
        filters: json['filters'] != null
            ? new Filters.fromJson(json['filters'])
            : null,
        menuColor: json["menu_color"],
        isFilters: json['is_filter'],
        customTags: json['custom_tags'] == null ? [] : json['custom_tags']);
  }

  static List<NestedSubCollections2> parsecollections2(collectionsJSON) {
    var lists = collectionsJSON['forth_level_collections'] as List;

    List<NestedSubCollections2> collectionsDetails = lists != null
        ? lists.map((data) => NestedSubCollections2.fromJson(data)).toList()
        : [];
    return collectionsDetails;
  }

  static List<Filters> parseFilters(collectionsJSON) {
    var lists = collectionsJSON['Filters'] as List;

    List<Filters> filterDetails = lists != null
        ? lists.map((data) => Filters.fromJson(data)).toList()
        : [];
    return filterDetails;
  }
}

class NestedSubCollections2 {
  String name;
  String shopifyId;
  Filters filters;
  bool isFilters;
  List customTags;
  String sortOrder;
  String menuColor;
  String sortingValue;

  NestedSubCollections2(
      {this.name,
      this.shopifyId,
      this.filters,
      this.customTags,
      this.sortingValue,
      this.menuColor,
      this.sortOrder,
      this.isFilters});

  factory NestedSubCollections2.fromJson(Map<dynamic, dynamic> json) {
    return NestedSubCollections2(
        sortingValue: json['sorting'],
        shopifyId: json['graphql_id'],
        name: json['title'],
        filters: json['filters'] != null
            ? new Filters.fromJson(json['filters'])
            : null,
        sortOrder: json['sort_order'],
        menuColor: json["menu_color"],
        isFilters: json['is_filter'],
        customTags: json['custom_tags'] == null ? [] : json['custom_tags']);
  }
}

class Filters {
  List<Item> size;
  List<Item> colors;
  List<Item> price;
  List<Item> type;

  Filters({this.size, this.colors, this.price, this.type});

  Filters.fromJson(dynamic json) {
    if (json['sizes'] != null) {
      size = new List<Item>();
      json['sizes'].forEach((v) {
        size.add(new Item.fromJson(v));
      });
    }
    if (json['colors'] != null) {
      colors = new List<Item>();
      json['colors'].forEach((v) {
        colors.add(new Item.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      price = new List<Item>();
      json['prices'].forEach((v) {
        price.add(new Item.fromJson(v));
      });
    }
    if (json['product_types'] != null) {
      type = new List<Item>();
      json['product_types'].forEach((v) {
        type.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.size != null) {
      data['sizes'] = this.size.map((v) => v.toJson()).toList();
    }
    if (this.colors != null) {
      data['colors'] = this.colors.map((v) => v.toJson()).toList();
    }
    if (this.price != null) {
      data['prices'] = this.price.map((v) => v.toJson()).toList();
    }
    if (this.type != null) {
      data['product_types'] = this.type.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Item {
  String item;
  bool isSelect = false;

  Item({this.item, this.isSelect});

  Item.fromJson(dynamic json) {
    item = json['item'];
  }

  void setSelected(bool select) {
    isSelect = select;
  }

  bool get isSelected => isSelect;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    return data;
  }
}

class FiltersList {
  int id;
  String title;
  List<String> tags;

  FiltersList({this.id, this.title, this.tags});

  FiltersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['tags'] = this.tags;
    return data;
  }
}
