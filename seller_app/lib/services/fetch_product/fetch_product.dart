import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/widget/our_flutter_toast.dart';

class FetchProductFirebase {
  Future<void> fetchproductfirebase(String category) async {
    try {
      var a = await FirebaseFirestore.instance
          .collection("All")
          .where("category", arrayContains: category);
      print("Value of a:");
      print(a.toString());
      var b = await a.orderBy("timestamp", descending: true);
      print("Value of b:");

      var c = await b.get();
      print(c);
    } catch (e) {
      OurToast().showErrorToast(
        e.toString(),
      );
    }
  }
}
