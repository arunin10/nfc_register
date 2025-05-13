import 'package:connectivity_plus/connectivity_plus.dart';

class AppVar{
  static String baseURL = 'https://atmosphere23apj-aruba.pmgasia.com/NfcControl/';
  static String fetchUserDetailsApi = '${baseURL}fetchUserDetails/';
  static String assignSerialNumberApi = '${baseURL}assignSerialNumber/';
  static String replaceSerialNumberApi = '${baseURL}replaceSerialNumber/';
  static String qrBindedUrl = 'https://app.pmgasia.com/r/n/i/14/';
}

class CheckInternetConnectivity{
  var internetAvailable = '';
  checkInternet() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internetAvailable = 'No';
    } else {
      internetAvailable = 'Yes';
    }
    return internetAvailable;
  }
}



