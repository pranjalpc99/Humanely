import 'package:Humanely/utils/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreDetail extends StatefulWidget {
  @override
  _ExploreDetailState createState() => _ExploreDetailState();
}

class _ExploreDetailState extends State<ExploreDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildDetailBody(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0.0,
        title: _buildDetailBar(),
      ),
    );
  }

  Widget _buildDetailBody(){
    return Column(
      children: <Widget>[
        Spacer(),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: _bottomDetailBar(),
        )
      ],
    );
  }

  Widget _bottomDetailBar(){
    return Container(
      child: Card(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
        ),
        margin: EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "8:35 pm, 2 July, 2020",//time[widget.index],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      "Man Shot, One Suspect in Custody",//title[widget.index],
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      "SV Road, Andheri West",//place[widget.index],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0,right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.notifications,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("512 views",style: TextStyle(color: Colors.white),),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Alert your friends",style: TextStyle(color: Colors.blue),),
                              Icon(Icons.arrow_forward_ios,color: Colors.blue,size: 12,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBar(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0,right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.remove_red_eye,color: Colors.black,),
          SizedBox(width: 10,),
          Text("512 views",style: TextStyle(color: Colors.black,fontSize: 16),),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.verified_user,color: Colors.green,),
                SizedBox(width: 10,),
                Text("Verified",style: TextStyle(color: Colors.green),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
