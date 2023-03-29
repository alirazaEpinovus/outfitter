class CountriesModel {
  List<CountryData> countryData;

  CountriesModel({this.countryData});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    if (json['countryData'] != null) {
      countryData = new List<CountryData>();
      json['countryData'].forEach((v) {
        countryData.add(new CountryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countryData != null) {
      data['countryData'] = this.countryData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryData {
  String name;
  String countryId;
  bool isStateRequired;
  List<States> states;

  CountryData({this.name, this.countryId, this.isStateRequired, this.states});

  CountryData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    countryId = json['country_id'];
    isStateRequired = json['isStateRequired'];
    if (json['states'] != null) {
      states = new List<States>();
      json['states'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    data['isStateRequired'] = this.isStateRequired;
    if (this.states != null) {
      data['states'] = this.states.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  int id;
  int idCountry;
  String name;
  String isoCode;
  int magentoRegionId;
  int active;
  String code;
  String regionId;

  States(
      {this.id,
      this.idCountry,
      this.name,
      this.isoCode,
      this.magentoRegionId,
      this.active,
      this.code,
      this.regionId});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCountry = json['id_country'];
    name = json['name'];
    isoCode = json['iso_code'];
    magentoRegionId = json['magento_region_id'];
    active = json['active'];
    code = json['code'];
    regionId = json['region_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_country'] = this.idCountry;
    data['name'] = this.name;
    data['iso_code'] = this.isoCode;
    data['magento_region_id'] = this.magentoRegionId;
    data['active'] = this.active;
    data['code'] = this.code;
    data['region_id'] = this.regionId;
    return data;
  }
}