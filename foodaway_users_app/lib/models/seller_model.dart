class Sellers{
  String? sellerUID;
  String? sellerName;
  String? sellerAvataUrl;
  String? sellerEmail;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerAvataUrl,
    this.sellerEmail
  }); 

  Sellers.fromJson(Map<String,dynamic> json){
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerAvataUrl = json["sellerAvataUrl"];
    sellerEmail = json["sellerEmail"];
  }
  Map<String,dynamic> tojson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["sellerUID"] = this.sellerUID;
    data["sellerName"] = this.sellerName;
    data["sellerAvataUrl"] = this.sellerAvataUrl;
    data["sellerEmail"] = this.sellerEmail;
    return data;
  }
}