import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/widget/our_flutter_toast.dart';

class RecommendationHistoryService {
  recommendationServiceFirebase(ProductModel productModel) async {
    print("Inside recommendation service");
    try {
      await FirebaseFirestore.instance
          .collection("RecommendationServices")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Recommendation")
          .doc(productModel.uid)
          .set({
        "timestamp": Timestamp.now(),
        "productUID": productModel.uid,
        "productName": productModel.name,
      }).then(
        (value) => print(
          "Recommendation Service added",
        ),
      );
    } catch (e) {
      OurToast().showErrorToast(e.toString());
    }
  }
}
