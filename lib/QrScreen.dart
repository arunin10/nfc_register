import 'dart:convert';
import 'dart:developer';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'utils/app_variables.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';


class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String regNo = '';
  String regNoVal = '';
  String nameVal = '';
  String companyVal = '';
  String categoryVal = '';

  ValueNotifier<dynamic> nfcResult = ValueNotifier(null);
  final TextEditingController _textEditingController = TextEditingController();
  FocusNode myFocusNode = FocusNode();


 @override
  void initState() {
    Future.delayed(Duration(seconds: 0),(){
        myFocusNode.requestFocus(); //auto focus on second text field.
    });
    NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      // Even if you're not doing anything here, it will still prevent the Android NFC handler from triggering.
    },
  );
    super.initState();
  }


@override
void dispose() {
  NfcManager.instance.stopSession();
  controller?.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text('Register NFC Tag'),
        centerTitle: true,
        backgroundColor: Color(0XFF546E7A),
      ),
      body: Column(
        children: <Widget>[
          // Container(
          //   height:screenHeight * 0.3,
          //   child: _buildQrView(context)),
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: TextFormField(
            //autofocus: true,
              focusNode: myFocusNode,
              controller: _textEditingController,
              //autofocus: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF546E7A))
                ),
                hintText: 'Scan QR code',
              ),
              style: TextStyle(fontSize: 20.0),
              onChanged: (val){
                qrScanCallApi(val);
              },
            ),
        ),
        SizedBox(height: 30.0,),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text('Reg No:', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0XFF546E7A)),))
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(regNoVal, style: TextStyle(fontSize: 22.0),))
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 15.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text('Badge Name:', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0XFF546E7A)),))
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(nameVal, style: TextStyle(fontSize: 22.0),))
        ),

        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 15.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text('Company:', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0XFF546E7A)),))
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(companyVal, style: TextStyle(fontSize: 22.0),))
        ),

        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 15.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text('Category:', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0XFF546E7A)),))
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(categoryVal, style: TextStyle(fontSize: 22.0),))
        ),
        
        Container(
          padding: const EdgeInsets.only(top:30.0),
          //height: 60.0,
            width: 100.0,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF546E7A),
                  minimumSize: const Size.fromHeight(44),
                  side: BorderSide(color:Color(0XFF546E7A)),
                ),
                onPressed: () {
                  _tagRead();
                  //alreadyRegisteredPopup('asdfasfds','sadfsafsafsd');
                },
                child: Text('Register', style: TextStyle(fontFamily:'OpenSans',fontWeight:FontWeight.bold,fontSize:18.0),),
              ),
          ),
          
          
        ],
      ),
    );
  }

  // void _tagRead() async {
  //   controller!.pauseCamera();
  //   bool isAvailable = await NfcManager.instance.isAvailable();
  //   if(isAvailable){
  //      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //       nfcResult.value = tag.data;
  //       var res = nfcResult.value;
  //       print(res['isodep']['identifier']);
  //       print(res['nfcb']['identifier']);
  //       // print(res['isodep']['identifier'][0]+''+res['isodep']['identifier'][1]);
  //       // print(res['isodep']['identifier'][1]);
  //       // print(res['isodep']['identifier'][0]+':'+res['isodep']['identifier'][1]+':'+res['isodep']['identifier'][2]+':'+res['isodep']['identifier'][3]);
  //       //print(17.toRadixString(16));
  //       //print(result.value);
  //       NfcManager.instance.stopSession();
  //       controller!.resumeCamera();
  //     });
  //   }
   
  // }

  void showPopup(){
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel:
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54.withOpacity(0.1),
          builder: (_) => new Dialog(
            backgroundColor: Colors.transparent,
            child: new Container(
              alignment: FractionalOffset.center,
              height: 280.0,
              width: double.infinity,
              //padding: const EdgeInsets.all(20.0),
              child:  new Image.asset(
                'assets/images/nfc_icon.png',
                fit: BoxFit.cover,
              )
            ),
          ));
  }

   

  void _tagRead() async {
    //playSoundSuccess();
    //playSoundFailure();
    
    setState(() {
      _textEditingController.text = '';
      myFocusNode.requestFocus();    
    });
    
    if(nameVal != '' && companyVal != '' && categoryVal != ''){
      showPopup();
      //controller!.pauseCamera();
      bool isAvailable = await NfcManager.instance.isAvailable();
      if(isAvailable){
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          nfcResult.value = tag.data;
          var res = nfcResult.value;
          // var val1 = res['isodep']['identifier'][0].toRadixString(16);
          // var val2 = res['isodep']['identifier'][1].toRadixString(16);
          // var val3 = res['isodep']['identifier'][2].toRadixString(16);
          // var val4 = res['isodep']['identifier'][3].toRadixString(16);
          // var val=val1+':'+val2+':'+val3+':'+val4;
          var val = '';
          if(res.containsKey('nfca')){
            for (var i = 0; i < res['nfca']['identifier'].length; i++) {
              if(i == 0){
                val = res['nfca']['identifier'][0].toRadixString(16);
              } else {
                val+= ':'+res['nfca']['identifier'][i].toRadixString(16);
              }
            }

            //NfcManager.instance.stopSession();
            assignNfcSerialNumApi(val);
          } else {
              Fluttertoast.showToast(
                msg: "Wrong NFC Tag",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
              ); 
          }
          
        });
      } 
    } else {
      Fluttertoast.showToast(
        msg: "Please scan first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      ); 
    }
  }


  playSoundSuccess() async{
   final player = AudioPlayer();
  //  await player.play(AssetSource('success.mp3'));
  await player.play(UrlSource('https://ebiz.pmgasia.com/web/arul/sound/success.mp3'));
  
  }

  playSoundFailure() async{
   final player = AudioPlayer();
   //await player.play(AssetSource('failure.mp3'));
   await player.play(UrlSource('https://ebiz.pmgasia.com/web/arul/sound/failure.mp3'));
  }


  qrScanCallApi(val) async{
    CheckInternetConnectivity internetChk = new CheckInternetConnectivity();
    var internetAvail = await internetChk.checkInternet();
    if(internetAvail == 'Yes'){
      var qrBindedUrl = AppVar.qrBindedUrl;
      if(val.contains(qrBindedUrl)){
        setState(() {
          regNo = val.split('/').last;
        });
        
        final response = await http.get(Uri.parse(AppVar.fetchUserDetailsApi+regNo));
        if(response.statusCode == 200){
          var jsonData = json.decode(response.body);
          print(jsonData);
          if(jsonData['Success'] == 1){
            playSoundSuccess(); 
            setState(() {
              regNoVal = jsonData['Details']['Reg_No'];
              nameVal = jsonData['Details']['Badge_Name'];
              companyVal = jsonData['Details']['Company'];
              categoryVal = jsonData['Details']['Category'];
               _textEditingController.text = '';
              myFocusNode.requestFocus();  
            });
          } else {
            playSoundFailure(); 
            Fluttertoast.showToast(
              msg: "Incorrect user",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            );   
            setState(() {
              _textEditingController.text = '';
              myFocusNode.requestFocus();  
            });
          }
        }
      } else { //incorrect qr code
        playSoundFailure();  
        Fluttertoast.showToast(
            msg: "Incorrect qr code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
          setState(() {
            _textEditingController.text = '';
            myFocusNode.requestFocus();  
          });
      }
    } else { // no internet
      playSoundFailure();
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      setState(() {
        _textEditingController.text = '';
        myFocusNode.requestFocus();  
      });
    }
  }

  void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

replaceNfcSerialNumApi(serialNum,regNo) async{
  CheckInternetConnectivity internetChk = new CheckInternetConnectivity();
    var internetAvail = await internetChk.checkInternet();
    if(internetAvail == 'Yes'){
      Map data1 = {'serialNum': serialNum.toString(), 'regNo': regNo};
      var replaceSerialNumberUrl = Uri.parse(AppVar.replaceSerialNumberApi);
      final response = await http.post(replaceSerialNumberUrl, body: data1);
      if(response.statusCode == 200){
        var jsonData = json.decode(response.body);
        if(jsonData['Success'] == 1){
            setState(() {
              regNo='';
              regNoVal='';
              nameVal='';
              companyVal='';
              categoryVal='';
              _textEditingController.text = '';
              myFocusNode.requestFocus();  
            });
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: jsonData['Message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
            );  
          } else {
              Fluttertoast.showToast(
                msg: jsonData['Message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
              );  
          }
      }
    }
}

  assignNfcSerialNumApi(serialNum) async{
    CheckInternetConnectivity internetChk = new CheckInternetConnectivity();
    var internetAvail = await internetChk.checkInternet();
    if(internetAvail == 'Yes'){
      
        Map data1 = {'serialNum': serialNum.toString(), 'regNo': regNo};
        var assignSerialNumberUrl = Uri.parse(AppVar.assignSerialNumberApi);
        final response = await http.post(assignSerialNumberUrl, body: data1);
       //printWrapped(response.body);
        if(response.statusCode == 200){
          var jsonData = json.decode(response.body);
          if(jsonData['Success'] == 1){
            Navigator.pop(context);
            setState(() {
              regNo='';
              regNoVal='';
              nameVal='';
              companyVal='';
              categoryVal='';
              _textEditingController.text = '';
              myFocusNode.requestFocus();  
            });
            Fluttertoast.showToast(
              msg: jsonData['Message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
            );  
          } else if(jsonData['Success'] == 2){
            Navigator.pop(context);
            alreadyRegisteredPopup(jsonData['popupHeader'], jsonData['Message'], serialNum.toString(), regNo);
          } else {
            Fluttertoast.showToast(
              msg: jsonData['Message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            );  
             setState(() {
              _textEditingController.text = '';
              myFocusNode.requestFocus();  
            }); 
          }
        }
    } else { // no internet
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      setState(() {
        _textEditingController.text = '';
        myFocusNode.requestFocus();  
      }); 
    }
     NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      // Even if you're not doing anything here, it will still prevent the Android NFC handler from triggering.
    },
  );
  
  }


  alreadyRegisteredPopup(popupHeader,popupContent,serialNo,regNo){
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return StatefulBuilder(builder: (BuildContext context, StateSetter mystate){
        return Container(
        height: MediaQuery.of(context).size.height < 700 ? MediaQuery.of(context).size.height * 0.3 :
        MediaQuery.of(context).size.height * 0.25,
        //color: Colors.grey,
        decoration: BoxDecoration(
          border: Border.all(color:Color(0XFFff8300))
        ),
        child: Column(
          children: [
            Container(
              height: 50.0,
              width: double.infinity,
              color:Color(0XFFff8300),
              child: Center(child: Text(popupHeader,style: TextStyle(color:Colors.white, fontSize: 20.0),)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(popupContent, style: TextStyle(fontSize: 16.0),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: 40.0,
                      width: 150.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size.fromHeight(44),
                          side: BorderSide(color:Color(0XFFff8300)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                          )
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        
                        child: Text('Cancel', style: TextStyle(color:Color(0XFFff8300)))
                      ),
                    ),
                    Container(
                      height: 40.0,
                      width: 150.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFff8300),
                          minimumSize: Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                          )
                        ),
                        onPressed: () {
                          //Navigator.pop(context);
                          replaceNfcSerialNumApi(serialNo,regNo);
                        },
                        child: Text('OK', style: TextStyle(color:Colors.white))
                      ),
                    ),
              ],),
            )
          ],
        ),
      );
      });
    }).whenComplete(() {
      setState(() {
        // unRegButton = true;
        // unRegLoading = false;
        // unRegDoneButton = false;
      });
    });
  }


  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  WillPopScope(
            //onWillPop: () async => false,
            onWillPop: (){
              return Future.value(false);
            },
            child: SimpleDialog(
                contentPadding: EdgeInsets.all(20.0),
                backgroundColor: Colors.white,
                children: <Widget>[
                  Center(
                    child: Row(children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0XFFff8300)),
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        "Please Wait....",
                        style: TextStyle(fontFamily:'OpenSans',color: Colors.black,fontSize:18.0),
                      )
                    ]),
                  )
                ]));
      });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }


}