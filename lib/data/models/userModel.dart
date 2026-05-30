//{"status":"success","data":
//{"_id":"69f7b4ae2cafe91e8b18da08",
//"email":"elahi@gmail.com",
//"firstName":"elahi",
//"lastName":"xoxo",
//"mobile":"01829833252",
//"createdDate":"2026-04-18T18:05:30.849Z"},
//"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NzgyMzE3OTUsImRhdGEiOiJlbGFoaUBnbWFpbC5jb20iLCJpYXQiOjE3NzgxNDUzOTV9.gPoExQTrlvGPv8SNMntjOn1Rr5pvT0lMs9bNTQaGjxY"}

class UserModel {
  final String id;
  final String email;
  final String fisrtName;
  final String lastName;
  final String mobile;
  final String photo;

  UserModel({
    required this.id,
    required this.email,
    required this.fisrtName,
    required this.lastName,
    required this.mobile,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      id: jsonData['_id'],
      email: jsonData['email'],
      fisrtName: jsonData['firstName'],
      lastName: jsonData['lastName'],
      mobile: jsonData['mobile'],
      photo: jsonData['photo'] ?? " ",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "firstName": fisrtName,
      "lastName": lastName,
      "mobile": mobile,
    };
  }
}
