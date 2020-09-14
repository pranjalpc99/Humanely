import 'package:Humanely/models/IncidentPostModel.dart';
import 'package:Humanely/models/emergency_card_tile.dart';
import 'package:Humanely/models/explore_card.dart';
import 'package:Humanely/models/explore_detail.dart';
import 'package:Humanely/models/scroll_behaviour.dart';
import 'package:Humanely/utils/sizes.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<String> _choices;
  int _defaultChoiceIndex;

  @override
  void initState() {
    super.initState();
    _defaultChoiceIndex = 0;
    _choices = [
      'Choice 1',
      'Choice 2',
      'Choice 3',
      'Choice 1',
      'Choice 2',
      'Choice 3',
      'Choice 1',
      'Choice 2',
      'Choice 3'
    ];
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
          itemCount: _choices.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                ChoiceChip(
                  label: Text(_choices[index]),
                  selected: _defaultChoiceIndex == index,
                  selectedColor: Colors.blue,
                  onSelected: (bool selected) {
                    setState(() {
                      _defaultChoiceIndex = selected ? index : 0;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Mumbai',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: Sizes.s18,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
        choiceChips(),
        StreamBuilder(
          stream: Firestore.instance.collection('posts').snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            var documents = snapshot.data?.documents ?? [];
            var postlist = documents.map((snapshot) => IncidentPostModel.fromJson(snapshot.data)).toList();
//            print("DATAAAAAAAAAAA");
//            print(postlist[0].title);
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator(),);
            }
            else {
              return Expanded(
                flex: 7,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: postlist.length,
                    itemBuilder: (context, index) {
                      print("DATAAAAAAAAAAA");
                      print(snapshot.data);
                      return EmergencyCard(postlist[index]);
//                  return ListTile(
//                    title: Text(
//                        snapshot.data.documents[index]["numar_telefon"]),
//                  );
                    }

                ),
              );
            }
          }
        ),
      ],
    );
  }
}
