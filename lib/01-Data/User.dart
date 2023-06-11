class User{
  // int id;
  String title;
  String Description;

  User({required this.title,required this.Description});
  Map<String,dynamic> UserMap(){
    var mapping = Map<String ,dynamic>();
    // mapping["id"] = id ?? "";
    mapping["title"] = title ?? "";
    mapping["Description"] = Description ?? "";
    return mapping;
  }
}