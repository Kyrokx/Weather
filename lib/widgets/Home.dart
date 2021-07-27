import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/models/KyTexte.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  String key = "towns";
  List<String> towns = [];

  String selectedCity;

  @override
  void initState() {
    super.initState();
    print("✅ Application lancer ✅");
    get();
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
                itemCount: towns.length +  2 ,
                itemBuilder: (context,i){

                  if (i == 0){
                    return DrawerHeader(
                        child: new Container(
                          color: Colors.indigo[700],
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new KyText("Cities", color: Colors.black,fontSize: 25.0,fontStyle: FontStyle.italic,),
                              new RaisedButton(
                                  elevation: 15.0,
                                  color: Colors.white,
                                  child: KyText("Add City"),
                                  onPressed: ((){
                                    addCity();
                                  })
                              )
                            ],
                          ),
                        )
                    );
                  } else if (i == 1){
                    return ListTile(
                      title: KyText("Current City", color: Colors.white,),
                      onTap: ((){
                        setState(() {
                          selectedCity = null;
                          Navigator.pop(context);
                        });
                      }),
                    );
                  } else {
                    String city = towns[i - 2];
                    return new ListTile(
                      title: new KyText(city,color: Colors.black,),
                      trailing: IconButton(
                        onPressed: ((){
                          setState(() {
                            delete(city);
                          });
                        }),
                        icon: Icon(Icons.delete, color: Colors.white,),
                      ),
                      onTap: ((){
                        setState(() {
                          selectedCity = city;
                          Navigator.pop(context);
                        });
                      }),
                    );
                  }
                }
            ),
          ),
        ),
        body: new Center(
          child: new KyText((selectedCity == null) ? "Current City" : selectedCity),
        )
    );


  }

  Future<Null> addCity () async {
    return showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return new SimpleDialog(
            title: KyText("Add City"),
            children: [
              new TextField(
                decoration: new InputDecoration(labelText: "Entrer the name of the city"),
                onSubmitted: ((String str){
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
    if (liste != null){
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
}
