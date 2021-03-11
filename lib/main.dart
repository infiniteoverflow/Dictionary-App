import 'dart:async';

import 'package:dictionary/dictionaryModel.dart';
import 'package:dictionary/dictionaryUtil.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Dictionary App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Dictionary dictionary = Dictionary();
  TextEditingController _controller = TextEditingController();

  StreamController? _streamController;
  Stream? _stream;

  Timer? debounce;

  search() async{
    if(_controller.text == null || _controller.text.length == 0) {
      _streamController?.add(null);
    } else {

      _streamController?.add('waiting');
      Dictionary dictionary = await getDictionary(_controller.text);
      if(dictionary.word == null) _streamController?.add("No data found");
      else _streamController?.add(dictionary);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _streamController = StreamController();
    _stream = _streamController?.stream;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.only(top:8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (text) {
                          if(debounce?.isActive?? false) debounce?.cancel();
                          debounce = Timer(Duration(seconds: 1), () {
                            search();
                          });
                        },
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Word",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.amber.withOpacity(0.6),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context,snapshot) {
          if(snapshot.data == null) {
            return Center(
              child: Text(
                "Enter a word to get meaning",
              ),
            );
          } else if(snapshot.data == "waiting"){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(snapshot.data == "No data found") {
            return Center(
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            Dictionary dictionary = snapshot.data as Dictionary;
            print(dictionary.definitions?.definitions[0].imageUrl);
            return ListView.builder(
              itemCount: dictionary.definitions?.definitions.length,
              itemBuilder:(context,index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (dictionary.word?.toUpperCase()?? "-" ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                " (${dictionary.definitions?.definitions[index].type?? "-"})",
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dictionary.definitions?.definitions[index].definition?? "-",
                              textAlign: TextAlign.center,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Example : "+(dictionary.definitions?.definitions[index].example?? "-"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            );
          }
        }
      ),
    );
  }
}
