import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCollection {
  static CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");
  static CollectionReference cmsCollection =
      FirebaseFirestore.instance.collection("CMS");
  static CollectionReference userWishlistCollection =
      FirebaseFirestore.instance.collection("UserWishlist");
  static CollectionReference userCartCollection =
      FirebaseFirestore.instance.collection("UserCart");
  static CollectionReference userAddressCollection =
      FirebaseFirestore.instance.collection("UserAddress");
  static CollectionReference userOrdersCollection =
      FirebaseFirestore.instance.collection("UserOrders");
  static CollectionReference productsCollection =
      FirebaseFirestore.instance.collection("Products");
  static CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection("Categories");
}
