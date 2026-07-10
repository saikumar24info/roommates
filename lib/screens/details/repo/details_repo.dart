import '../../../global.dart';

abstract class DetailsRepo {
  Future<String?> registerUser(
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
  Future<String?> registerUser(fullName, hostelName, roomNumber,
      joiningDate, roomType, amount, hostelAddress, phoneNumber) async {
    return hostelManagement.registerUser(
      name: fullName,
      phoneNumber: phoneNumber,
      hostelName: hostelName,
      roomNo: roomNumber,
      joiningDate: joiningDate,
      roomType: roomType,
      amount: amount,
      hostelAddress: hostelAddress,
    );
  }
}
