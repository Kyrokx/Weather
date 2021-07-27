import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/models/KyTexte.dart';
import 'package:weather/models/My_flutter_app_icon.dart';
import 'package:weather/models/Temps.dart';

class Home extends StatefulWidget {
  Home(String ville, {Key key, this.title}) : super(key: key) {
    this.villeDeLutilisateur = ville;
  }

  String villeDeLutilisateur;
  final String title;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  var i;
  String key = "towns";
  List<String> towns = [];
  String villeChoisie;
  Temps tempsActuel;
  String nameCurrent = "Ville actuelle";

  String selectedCity;


  @override
  void initState() {
    super.initState();
    print("✅ Application lancer ✅");
    get();
    appelApi();
    nameCurrent = widget.villeDeLutilisateur;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      drawer: new Drawer(
          child: new Container(
            color: Colors.indigo,
            child: new ListView.builder(
                itemCount: towns.length + 2,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return DrawerHeader(
                        child: new Container(
                          color: Colors.indigo[700],
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new KyText(
                                "Cities",
                                color: Colors.black,
                                fontSize: 25.0,
                                fontStyle: FontStyle.italic,
                              ),
                              new RaisedButton(
                                  elevation: 15.0,
                                  color: Colors.white,
                                  child: KyText("Add City"),
                                  onPressed: (() {
                                    addCity();
                                  }))
                            ],
                          ),
                        ));
                  } else if (i == 1) {
                    return ListTile(
                      title: KyText(
                        nameCurrent,
                        color: Colors.white,
                      ),
                      onTap: (() {
                        setState(() {
                          appelApi();
                          villeChoisie = null;
                          appelApi();
                          Navigator.pop(context);
                          appelApi();
                        });
                      }),
                    );
                  } else {
                    String city = towns[i - 2];
                    return new ListTile(
                      title: new KyText(
                        city,
                        color: Colors.black,
                      ),
                      trailing: IconButton(
                        onPressed: (() {
                          setState(() {
                            delete(city);
                          });
                        }),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onTap: (() {
                        setState(() {
                          villeChoisie = city;
                          appelApi();
                          Navigator.pop(context);
                          appelApi();
                        });
                      }),
                    );
                  }
                }),
          ),
        ),
      body: (tempsActuel == null)
          ? new Center(
              child: new Text((villeChoisie == null)
                  ? widget.villeDeLutilisateur
                  : villeChoisie),
            )
          : new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage(assetName()), fit: BoxFit.cover),
              ),
              padding: EdgeInsets.all(20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KyText(tempsActuel.name, fontSize: 30.0),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      KyText("${tempsActuel.temp.toInt()}°C", fontSize: 60.0),
                      Expanded(child: new Image.asset(tempsActuel.icon))
                    ],
                  ),
                  KyText(tempsActuel.main, fontSize: 30.0),
                  KyText(tempsActuel.description, fontSize: 25.0),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Icon(
                            MyFlutterApp.temperatire,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          KyText("${tempsActuel.pressure}", fontSize: 20.0)
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Icon(
                            MyFlutterApp.droplet,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          KyText("${tempsActuel.humidity}", fontSize: 20.0)
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Icon(
                            MyFlutterApp.arrow_upward,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          KyText("${tempsActuel.temp_max}", fontSize: 20.0)
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Icon(
                            MyFlutterApp.arrow_downward,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          KyText("${tempsActuel.temp_min}", fontSize: 20.0)
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  String assetName() {
    if (tempsActuel.icon.contains("d")) {
      return "assets/n.jpg";
    } else if (tempsActuel.icon.contains("01") ||
        tempsActuel.icon.contains("02") ||
        tempsActuel.icon.contains("03")) {
      return "assets/d1.jpg";
    } else {
      return "assets/d2.jpg";
    }
  }

  Future<Null> addCity() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return new SimpleDialog(
            title: KyText("Add City"),
            children: [
              new TextField(
                decoration: new InputDecoration(
                    labelText: "Entrer the name of the city"),
                onSubmitted: ((String str) {
                  setState(() {
                    add(str);
                    Navigator.pop(buildContext);
                  });
                }),
              )
            ],
          );
        });
  }

  void get() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> liste = await sharedPreferences.getStringList(key);
    if (liste != null) {
      towns = liste;
    }
  }

  void add(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    towns.add(str.toString());
    await sharedPreferences.setStringList(key, towns);
    get();
  }

  void delete(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    towns.remove(str);
    await sharedPreferences.setStringList(key, towns);
    get();
  }

  void appelApi() async {
    String str;
    if (villeChoisie == null) {
      str = widget.villeDeLutilisateur;
    } else {
      str = villeChoisie;
    }
    List<Address> coord = await Geocoder.local.findAddressesFromQuery(str);
    if (coord != null) {
      final lat = coord.first.coordinates.latitude;
      final lon = coord.first.coordinates.longitude;
      String lang = Localizations.localeOf(context).languageCode;
      final key = "YOUR KEY"; // GO ON: https://openweathermap.org/api

      String urlApi =
          "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&lang=$lang&APPID=$key";

      final reponse = await http.get(urlApi);
      if (reponse.statusCode == 200) {
        Temps temps = new Temps();
        Map map = json.decode(reponse.body);
        temps.fromJSON(map);
        setState(() {
          tempsActuel = temps;
        });
      }
    }
  }
}
