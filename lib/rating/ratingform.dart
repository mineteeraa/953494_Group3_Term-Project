import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:group4/model/rating.dart';
import 'package:group4/rating/ratinglist.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final formKey = GlobalKey<FormState>();
  late Rating myRating;
  //เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _studentCollection = FirebaseFirestore.instance.collection("rating");

  var rate;
  var myComment;

  late final _ratingController;
  late double _rating;

  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isRTLMode = false;

  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isRTLMode ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40.0,
            ),
            _heading('Rating for .....'),
            _ratingBar(_ratingBarMode),
            SizedBox(height: 20.0),
            Text(
              'Rating: $_rating',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 20.0),

            // comment part
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Comment for ....",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.teal[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "comment",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String comment) {
                      myComment = comment;
                    },
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await _studentCollection.add({
                                  "rating": '${rate}',
                                  "comment": myComment,
                                });
                                formKey.currentState!.reset();
                              }
                            },
                            child: Text("Confirm"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                fixedSize: const Size(100, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RatingList()),
                              );
                            },
                            child: Text("rating list"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                fixedSize: const Size(100, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // End comment part

            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingBar(int mode) {
    return RatingBar.builder(
      initialRating: _initialRating,
      minRating: 1,
      allowHalfRating: true,
      unratedColor: Colors.teal.withAlpha(50),
      itemCount: 5,
      itemSize: 50.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.teal[300],
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
          rate = rating;
        });
      },
      updateOnDrag: true,
    );
  }
}

Widget _heading(String text) => Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 24.0,
            color: Colors.teal[800],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );