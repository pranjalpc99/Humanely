import 'package:Humanely/screens/post_detail.dart';
import 'package:Humanely/utils/auth.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'IncidentPostModel.dart';

class EmergencyCard extends StatefulWidget {
  final IncidentPostModel postModel;

  EmergencyCard(this.postModel);

  @override
  _EmergencyCardState createState() => _EmergencyCardState(postModel);
}

class _EmergencyCardState extends State<EmergencyCard> {
  IncidentPostModel model;
  int state=0;

  _EmergencyCardState(this.model);

  /* Widget get IncidentCard {
    return Container(
      child: new Card(
          color: HexColor("#333333"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${model.timestamp}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            model.title == null ? "" : model.title,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            model.place,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 16.0),
                          width: 24.0,
                          height: 24.0,
                          child: Image.asset("assets/images/pray.png")),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: CachedNetworkImage(
                    imageUrl: model.image,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Card(
                          color: HexColor("#888888"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12.0),
                            child: Text("Comment"),
                          )),
                    ),
                    CircleAvatar(
                      child: Icon(Icons.share),
                      backgroundColor: HexColor("#555555"),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Card(
          color: HexColor("#333333"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${model.timestamp}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            model.title == null ? "" : model.title,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0,bottom: 8.0),
                          child: Text(
                            model.place,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 16.0),
                          width: 24.0,
                          height: 24.0,
                          child: Image.asset("assets/images/pray.png")),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostDetail(model.title,
                                model.image, model.place, model.timestamp)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: CachedNetworkImage(
                      imageUrl: model.image,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 12.0),
                        child: Text(
                          model.uploader,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          child: InkWell(
                              onTap: (){
                                print(model.postnum);
                                Auth.store.collection('posts').document(model.postnum).get().then((value) {
                                  String downCount = "";
                                  downCount = value.data['downvotes'];
                                  print("c:" + downCount);
                                  int dC = int.parse(downCount) - 1;
                                  print(dC);
                                  setState(() {
                                    model.downvotes = dC.toString();
                                    state = -1;
                                  });
                                  Auth.store.collection('posts').document(model.postnum).updateData({
                                    'downvotes': dC.toString(),
                                  });
                                });
                              },
                              child: state == -1 ? Icon(Icons.thumb_down_alt_rounded,color: Colors.red,): Icon(Icons.thumb_down_alt_outlined)
                          ),
                          backgroundColor: HexColor("#555555"),
                        ),
                        SizedBox(height: 5,),
                        Text(model.downvotes,style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          child: InkWell(
                            onTap: (){
                              print(model.postnum);
                              Auth.store.collection('posts').document(model.postnum).get().then((value) {
                                String downCount = "";
                                downCount = value.data['upvotes'];
                                print("c:" + downCount);
                                int dC = int.parse(downCount) + 1;
                                print(dC);
                                setState(() {
                                  model.upvotes = dC.toString();
                                  state = 1;
                                });
                                Auth.store.collection('posts').document(model.postnum).updateData({
                                  'upvotes': dC.toString(),
                                });
                              });
                            },
                              child: state == 1 ? Icon(Icons.thumb_up_rounded,color: Colors.green,) :Icon(Icons.thumb_up_alt_outlined)
                          ),
                          backgroundColor: HexColor("#555555"),
                        ),
                        SizedBox(height: 5,),
                        Text(model.upvotes,style: TextStyle(color: Colors.white),),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )),
    );
  }

  increaseDownVote() {
    print("downvote" + model.postnum);
    String postnum = "";
    String downCount = "";
    Auth.store.collection('posts').document(postnum).get().then((value) {
      postnum = value.data['postnum'];
      downCount = value.data['downvotes'];
      print("c:" + downCount);
      int dC = int.parse(downCount) - 1;
      print(dC);
      Auth.store.collection('posts').document(postnum).updateData({
        'downvotes': dC.toString(),
      });
    });
  }
}
