import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coronavirus/note.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';

void main() {
  Admob.initialize(getAppId());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Open_Sans',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> _notes = List<Note>();

  int _randomNumber = 0;

  Future<List<Note>> fetchNotes() async {
    var url =
        'https://raw.githubusercontent.com/2028ljay/corona/master/statement.json';
    var response = await http.get(url);

    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Note.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });

    super.initState();
  }

  void _random() {
    setState(() {
      var randomizer = new Random(); // can get a seed as a parameter

      // Integer between 0 and 100 (0 can be 100 not)
      var num = randomizer.nextInt(_notes.length);

      _randomNumber = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.grey[700],
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Container(
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: AdmobBannerSize.BANNER,
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      '  CORONAVIRUS DAILY FACTS  ',

                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          ),

                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        width: 400,
                        height: 400,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(_notes[_randomNumber].text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,

                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Text(_notes[_randomNumber].maahSom,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,

                                  fontSize: 25,

                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FloatingActionButton(

                            shape: RoundedRectangleBorder(

                                borderRadius: new BorderRadius.circular(20.0),
                                ),
                            backgroundColor: Colors.black54,
                            splashColor: Colors.grey,
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: _notes[_randomNumber].maahSom,
                                ),
                              );
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'FACT coppied, GO AND SHARE')));
                            },
                            child: Icon(Icons.content_copy,)),
                        FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              ),
                          backgroundColor: Colors.black54,
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            _random();
                          },
                          child: Icon(Icons.loop),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: _notes.length,
        ),
      ),
    );
  }
}

String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544~3347511713';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1781296629587746~7521123299';
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-6094776116326670~8985686810';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1781296629587746/4316568976';
  }
  return null;
}