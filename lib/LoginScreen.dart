
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'QrScreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            // The containers in the background
             Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .65,
                  color: Color(0XFF546E7A),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .35,
                  color: Color(0XFFc5d3d9)
                )
              ],
            ),
            // The card widget with top padding, 
            // incase if you wanted bottom padding to work, 
            // set the `alignment` of container to Alignment.bottomCenter
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .20,
                      right: 20.0,
                      left: 20.0),
                  child: Image(
                            width: 130.0,
                            image: AssetImage('assets/images/logo.png'),
                          )
                ),
                SizedBox(height: 30.0,),
                Text('Event Registration',style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold,))
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .58,
                  right: 20.0,
                  left: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top:20.0,left: 10.0,right: 10.0,bottom: 10.0),
                        child: TextField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            //border: OutlineInputBorder(),
                            
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0XFF546E7A))
                            ),
                            hintText: 'Username',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top:20.0),
                          width: 100.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0XFF546E7A),
                                minimumSize: const Size.fromHeight(44),
                                side: BorderSide(color:Color(0XFF546E7A)),
                              ),
                              onPressed: () {
                                _loginBtnPressed();
                              },
                              child: Text('Login', style: TextStyle(fontFamily:'OpenSans',fontWeight:FontWeight.bold,fontSize:18.0),),
                            ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

    _loginBtnPressed(){
      var uname = userNameController.text;
      if(uname == ''){
         Fluttertoast.showToast(
            msg: "Please type username",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
      } else {
           //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => QrScreen()));
           Navigator.push(context, MaterialPageRoute(builder: (context) => QrScreen()));
      }
    }
  }
  

