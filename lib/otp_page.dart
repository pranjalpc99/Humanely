import 'package:Humanely/home_page.dart';
import 'package:Humanely/user_register.dart';
import 'package:Humanely/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;


MediaQueryData queryData;
String phone;

class OTPPage extends StatefulWidget {
  final bool otpstate;
  final String number;
  OTPPage(this.otpstate,this.number);
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  //TextEditingController controller = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  FirebaseUser _firebaseUser;
  String _status;

  AuthCredential _phoneAuthCredential;
  static String _verificationId;
  int _code;

  Future<void> _submitPhoneNumber(String number) async {
    print("in _submitPhoneNumber");
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91 " + number.toString().trim();
    print(phoneNumber);
    phone = phoneNumber;

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      this._phoneAuthCredential = phoneAuthCredential;
      print("phoneAuth");
      print(phoneAuthCredential);
      _login();
      setState(() {
        _status += 'verificationCompleted\n';
      });
//      this._phoneAuthCredential = phoneAuthCredential;
//      print("phoneAuth");
//      print(phoneAuthCredential);
//      _login();
    }

    void verificationFailed(AuthException error) {
      print('verificationFailed');
      setState(() {
        _status += '$error\n';
      });
      print(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      _verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code.toString());
      setState(() {
        _status += 'Code Sent\n';
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  void _submitOTP(String otp) {
    /// get the `smsCode` from the user
    String smsCode = otp.toString().trim();
    print("in otp");
    print(otp);

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);

    _login();
  }

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
  }

  Future<void> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    print(_verificationId);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
        _firebaseUser = authRes.user;
        print(_firebaseUser.toString());
      });
      print("signin success");
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserRegister()));
//      setState(() {
//        _status += 'Signed In\n';
//        print("signin success");
//      });
    } catch (e) {
//      setState(() {
//        _status += e.toString() + '\n';
//      });
      print(e.toString());
    }
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      _status =
      (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
      if(_firebaseUser == null)
        print("Not logged in");
      else{
        print("Already logged in");
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;

    TextStyle style38 = new TextStyle(
      inherit: true,
      fontSize: 38.0,
    );

    return Scaffold(
      backgroundColor: Color(0xff060606),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    InkWell(
                      onTap: (){Navigator.pop(context);},
                      child: Text(
                        'Back',
                        style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30.0,),
                Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.2,
                    child: Image.asset('assets/images/otp_img.png')),
                SizedBox(height: 50.0,),
                Text('OTP VERIFICATION',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    fontSize: SizeConfig.safeBlockHorizontal*6,
                  ),),
                if(widget.otpstate==false)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Please enter your mobile number to verify your account',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockHorizontal*3.5,
                    ),
                    textAlign: TextAlign.center,),
                ),
                if(widget.otpstate==true)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('We have sent and OTP to '+widget.number,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal*4,
                      ),
                      textAlign: TextAlign.center,),
                  ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,),
                if(widget.otpstate==false)
                AddPhoneNumber(_phoneNumberController),
                if(widget.otpstate==true)
                VerifyOTP(_otpController)
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class VerifyOTP extends StatelessWidget{

  TextEditingController _controller;
  VerifyOTP(this._controller);

  getPhoneNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String num = preferences.getString("phoneNumber");
    return num;
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;

    TextStyle style38 = new TextStyle(
      inherit: true,
      fontSize: 38.0,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left :8.0, right: 8.0),
          child: Card(
            color: Color(0xff060606),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.blue),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10.0,),
//                  Transform.rotate(
//                      angle: 270 * math.pi / 180,
//                      child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
//                  SizedBox(width: 10.0,),
//                  Text("(+91)", style: TextStyle(
//                      fontFamily: 'Poppins',
//                      fontSize: 18.0,
//                      color: Colors.white
//                  ),),
//                  SizedBox(width: 10.0,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      controller: _controller,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        color: Colors.white
                    ),),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.05,),
        Padding(
          padding: const EdgeInsets.only(left :8.0, right: 8.0),
          child: Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      print(_controller.text);
                      //String num =  getPhoneNumber();
                      _OTPPageState()._submitOTP(_controller.text);
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: SizeConfig.safeBlockHorizontal*5,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Didn’t receive OTP ?',style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w100,
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal*3.5,
            ),),
            SizedBox(width: 50.0,),
            InkWell(
              onTap: (){
                //phone = _controller.text;
                _OTPPageState()._submitPhoneNumber(phone);
                },
              child: Text('RESEND OTP',style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                fontSize: SizeConfig.safeBlockHorizontal*3.5,
              ),),
            )
          ],
        )
      ],
    );
  }

}

class AddPhoneNumber extends StatelessWidget{

  TextEditingController _controller;
  AddPhoneNumber(this._controller);

  savePhoneNumber(String number) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String num = number;
    preferences.setString("phoneNumber", num);
  }

  //_OTPPageState __otpPageState = new _OTPPageState();

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;

    TextStyle style38 = new TextStyle(
      inherit: true,
      fontSize: 38.0,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left :8.0, right: 8.0),
          child: Card(
            color: Color(0xff060606),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.blue),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 50.0,),
                  Transform.rotate(
                      angle: 270 * math.pi / 180,
                      child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                  SizedBox(width: 10.0,),
                  Text("(+91)", style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      color: Colors.white
                  ),),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      controller: _controller,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        color: Colors.white
                    ),),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.05,),
        Padding(
          padding: const EdgeInsets.only(left :8.0, right: 8.0),
          child: Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      //__otpPageState.verifyPhone();
                      savePhoneNumber(_controller.text);
                      _OTPPageState()._submitPhoneNumber(_controller.text);
                      //print(_controller.text);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OTPPage(true,_controller.text)));
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Send Code',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: SizeConfig.safeBlockHorizontal*5,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}
