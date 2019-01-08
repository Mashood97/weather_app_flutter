import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; //dateformat library

Map _data;
List _features;

void main() async {
  _data = await getJson();

  //  print(_data['features'][0]['properties']);
  _features = _data['features'];

  runApp(new MaterialApp(
    title: "Quakes",
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Quakes"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Container(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd) return new Divider();
              final index = position ~/2; // diving position by 2 and returns result as int

              var format = new DateFormat.yMMMd("en_US").add_jm();//format date with intl library
              var date =format.format( new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000,
                  isUtc: true));
              return new ListTile(
                  title: new Text(
                      "At: $date",
                      style: new TextStyle(fontSize: 15.9,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w400)),
                  subtitle: new Text(
                    "${_features[index]['properties']['place']}",
                    style: new TextStyle(color: Colors.grey,
                        fontSize: 14.9,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),),

                  leading: new CircleAvatar(
                    backgroundColor: Colors.green,
                    child: new Text("${_features[index]['properties']['mag']}",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),),
                  ),
                  onTap: (){
                    _showOnTapMessage(context, "${_features[index]['properties']['title']}");
                  },
              );
            }),
      ),
    );
  }
void _showOnTapMessage(BuildContext context,String message)
{
  var alert = new AlertDialog(
      title: new Text("Quake App"),
      content:new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed:(){
          Navigator.pop(context);
      },
      child : new Text('Ok'),
    ),
    ],
  );
  showDialog(context: context,child:alert);
}
}

Future<Map> getJson() async
{
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}
