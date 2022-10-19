import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/widget/our_flutter_toast.dart';

class FetchProductFirebase {
  Future<void> fetchproductfirebase(String category) async {
    try {
      var a = FirebaseFirestore.instance
          .collection("RecommendationServices")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Recommendation")
          .where("timestamp", isNotEqualTo: "dfaas");
      print("Value of a:");
      print(a.toString());
      var b = await a.orderBy(
        "timestamp",
        descending: true,
      );
      print(b.get());
      print("Value of b:");

      var c = await b.where("uid", isNotEqualTo: "safd");
      // print(c);
    } catch (e) {
      print(e);
      OurToast().showErrorToast(
        e.toString(),
      );
    }
  }
}
