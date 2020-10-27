/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:Humanely/MLKIT.dart';
import 'package:Humanely/fragments/explore.dart';
import 'package:Humanely/home_page.dart';
import 'package:Humanely/models/IncidentPostModel.dart';
import 'package:Humanely/models/scroll_behaviour.dart';
import 'package:Humanely/utils/app_theme.dart';
import 'package:Humanely/utils/auth.dart';
import 'package:Humanely/utils/data_repository.dart';
import 'package:Humanely/utils/months.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewImageScreen extends StatefulWidget {
  final String imagePath;
  List labeltags;
  PreviewImageScreen({this.labeltags, this.imagePath});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {

  final DataRepository repository = DataRepository();
  bool showSpinner = false;

  List<String> _tags;
  int _defaultTagIndex;
  String title="";
  String timestamp;
  String place;
  String votes;
 String description;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;
  String number="";
  String name='';
  String count="";
  String mypost="";

  @override
  void initState() {
    _defaultTagIndex = 0;
    _tags = [
      'Fire',
      'Accident',
      'Flood'
    ];
    //print("IMAGE PATH" + widget.imagePath);
    _getCurrentLocation();
    getPhoneNumber();
    getCountOfPost();
  }

  getCountOfPost(){
    Firestore.instance
        .collection('numOfPosts')
        .document('countOfPost')
        .get()
        .then((value) {
          count = value.data['count'];
          //int i = int.parse(count);
          //count = i.toString();
        });
  }

  Future<bool> getPhoneNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    number = preferences.getString("phoneNumber");
    return number == null;
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.subLocality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Widget choiceChips() {
    return Expanded(
      flex: 1,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 8.0),
          scrollDirection: Axis.horizontal,
          itemCount: widget.labeltags.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                ChoiceChip(
                  label: Text(widget.labeltags[index]),
                  selected: _defaultTagIndex == index,
                  selectedColor: Colors.blue,
                  onSelected: (bool selected) {
                    setState(() {
                      _defaultTagIndex = selected ? index : 0;
                    });
                  },
                  backgroundColor: Colors.black45,
                  labelStyle: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10.0,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _postTopBar(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.chevron_left),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text("New Post"),
          Expanded(
            child: InkWell(
              onTap: () async {
                setState(() {
                  showSpinner = true;
                });
                //print("title is: "+title);
                String dtn = DateTime.now().toString();
                String d = dtn.substring(0,dtn.indexOf(" "));
                String t = dtn.substring(dtn.indexOf(" "),dtn.indexOf("."));
                String y = d.substring(0,4);
                String m = d.substring(5,7);
                String dt = d.substring(8);
                int mIndex = int.parse(m);
                String timestamp = dt + " " +Months().mon[mIndex] +", "+y +" "+t;
                //print(timestamp);
                final file = File(widget.imagePath);
                String n = basename(widget.imagePath);
                StorageReference storageReference = FirebaseStorage.instance.ref().child(n);
                final StorageUploadTask uploadTask = storageReference.putFile(file);
                final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
                final String url = (await downloadUrl.ref.getDownloadURL());
                print("URL is $url");
                IncidentPostModel newPost = IncidentPostModel(title: title,id: dtn,postnum: count,timestamp: timestamp,place: _currentAddress,upvotes: "0",downvotes: "0",uploader: name,image: url);
                //repository.addPost(newPost,count);
                Firestore.instance.collection("posts").document(count).setData(newPost.toJson());
                int i = int.parse(count)+1;
                Auth.store.collection('numOfPosts').document('countOfPost').updateData({
                  'count': i.toString(),
                });
                int p = int.parse(mypost) + 1;
                Auth.store.collection('Users').document(number).updateData({
                  'posts': p.toString(),
                });
                // MLKit classifier = new MLKit();
                // _tags=  classifier.detectLabels(widget.imagePath) as List<String>;


                 //uploadPic();
                Fluttertoast.showToast(msg: "Post Successful",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white70,
                    textColor: Colors.black,
                    fontSize: 16.0);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text(
                "POST",
                textAlign: TextAlign.end,
                style: TextStyle(color: AppTheme.darkTheme.colorScheme.secondary),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: _postTopBar(context),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
          future: getPhoneNumber(),
          builder: (buildContext, snapshot) {
            if(snapshot.hasData){
              Firestore.instance
                  .collection('Users')
                  .document(number)
                  .get()
                  .then((value) {
                    name = value.data['firstName'] + " " + value.data['lastName'];
                    mypost = value.data['posts'];
                  });
              return ModalProgressHUD(
                inAsyncCall: showSpinner,
                color: Colors.blue,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(
                                File(widget.imagePath),
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height / 5,
                                width: MediaQuery.of(context).size.width / 5,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                  hintText: "Title",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white54)),
                              onChanged: (value) {
                                //print(value);
                                title = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0),
//                child: Text(
//                  "Add Description",
//                  style: TextStyle(color: Colors.white,
//                  fontSize: 18),
//                ),
                        child:  TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                              hintText: "Add Description",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle: TextStyle(color: Colors.white)),
                          onChanged: (value) {
                            //print(value);
                            description  = value;
                          },
                        ),

                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0),
                        child: Text(
                          "Add Tags",
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                      ),
                      choiceChips(),
                      Spacer(flex: 3,),
//              Flexible(
//                flex: 1,
//                child: Container(
//                  padding: EdgeInsets.all(60.0),
//                  child: RaisedButton(
//                    onPressed: () {
//                      getBytesFromFile().then((bytes) {
//                        Share.file('Share via:', basename(widget.imagePath),
//                            bytes.buffer.asUint8List(), 'image/png');
//                      });
//                    },
//                    child: Text('Share'),
//                  ),
//                ),
//              ),
                    ],
                  ),
                ),
              );
            }
           return CircularProgressIndicator();
          },

        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    print("IMAGE PATH" + widget.imagePath);
    Uint8List bytes = File(widget.imagePath).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }

}
