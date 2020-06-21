import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'config/size_config.dart';


MediaQueryData queryData;

class OTPPage extends StatefulWidget {
  final bool otpstate;
  final String number;
  OTPPage(this.otpstate,this.number);
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {


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
              AddPhoneNumber(),
              if(widget.otpstate==true)
              VerifyOTP()
            ],
          ),
        ),
      ),
    );
  }

}

class VerifyOTP extends StatelessWidget{
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
              padding: const EdgeInsets.all(16.0),
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
                  Text("7506133234", style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      color: Colors.white
                  ),),
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
                    onTap: (){},
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
            Text('RESEND OTP',style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.green,
              fontSize: SizeConfig.safeBlockHorizontal*3.5,
            ),)
          ],
        )
      ],
    );
  }

}

class AddPhoneNumber extends StatelessWidget{

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
              padding: const EdgeInsets.all(16.0),
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
                  Text("7506133234", style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      color: Colors.white
                  ),),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OTPPage(true,"7506133234")));
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
