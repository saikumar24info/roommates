import 'package:firebase_database/firebase_database.dart';

import '../../../global.dart';

abstract class DetailsRepo {
  Future<DatabaseReference> registerUser(
    String fullName,
    String hostelName,
    int roomNumber,
    String joiningDate,
    String roomType,
    double amount,
    String hostelAddress,
    String phoneNumber,
  );
}

class DetailsRepoImpl extends DetailsRepo {
  @override
  Future<DatabaseReference> registerUser(fullName, hostelName, roomNumber,
      joiningDate, roomType, amount, hostelAddress, phoneNumber) async {
    DatabaseReference userRef = await hostelManagement.registerUser(
      name: fullName,
      phoneNumber: phoneNumber,
      hostelName: hostelName,
      roomNo: roomNumber,
      joiningDate: joiningDate,
      roomType: roomType,
      amount: amount,
      hostelAddress: hostelAddress,
    );
    return userRef;
  }
}
