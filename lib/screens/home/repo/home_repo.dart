import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../utils/shared_prefs.dart';

class HomeRepo {
  Future<Map<String, dynamic>> getMyStay() async {
    String? token = await AppLocalPrefs.getProfileToken();
    try {
      DatabaseReference dataRef = FirebaseDatabase.instance
          .ref('Hyderabad/KPHB/Manikanta Boys Hostel/MyStay/$token');
      DataSnapshot snapshot = await dataRef.get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        return {"status": 200, "message": 'No Data Found'};
      }
    } on FirebaseException catch (e) {
      return {
        "status": 500,
        "error": "Firebase error: ${e.message}",
      };
    } on TimeoutException catch (e) {
      return {
        "status": 408,
        "error": "Request timeout: ${e.message}",
      };
    } catch (e) {
      return {
        "status": 400,
        "error": "Unexpected error: ${e.toString()}",
      };
    }
  }
}
