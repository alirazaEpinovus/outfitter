class ScanHistroyModel{
  int scanrecentid;
  String scancode;
  

  ScanHistroyModel({
    this.scanrecentid,
    this.scancode
  });

  factory ScanHistroyModel.fromJson(Map<String,dynamic> data){
return ScanHistroyModel(
  scanrecentid: data['scanrecentid'],
  scancode: data['scancode']
);
  }
}