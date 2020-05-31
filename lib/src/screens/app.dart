import 'dart:convert';

import 'package:dx_qasim_task/models/list_argument.dart';
import 'package:dx_qasim_task/models/model.dart';
import 'package:dx_qasim_task/src/screens/list_item.dart';
import 'package:dx_qasim_task/widgets/feature_button.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dx_qasim_task/blocs/bloc.dart';
import 'package:http/http.dart' as http;

//Align code cmmand: alt+shift+F
class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Model> _list = List<Model>();
  Widget _listBtnIcon = SvgPicture.asset("images/list_view.svg");
  Widget _searchBtnIcon = SvgPicture.asset("images/search.svg");
  Widget _filterBtnIcon = SvgPicture.asset("images/filters.svg");
  Widget _mapBtnIcon = SvgPicture.asset("images/map_view.svg");
  bool _searchIsMap = false;
  bool _filterIsMap = false;
  bool _listIsMp = false;
  Widget homeWidget = new Image.asset(
    "images/map.png",
    fit: BoxFit.cover,
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
  );
  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        _list.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
        child: MaterialApp(
            routes: {
          ListItem.routeName: (context) => ListItem(),
        },
            home: Scaffold(
              body: StreamBuilder(
                stream: bloc.bodyStream,
                initialData: homeWidget,
                builder: (context, snapshot) {
                  return snapshot.data;
                },
              ),
              appBar: AppBar(
                actions: <Widget>[
                  FeatureButton(
                      //custom search button
                      icon: _searchBtnIcon, //ernorary operator to navigate.
                      titlText: 'Search',
                      featureId: 'feature1',
                      mainText:
                          'Search for any specific Pitch. Search can be perform using:',
                      mainText2: '• Pitch Title\n• Cretaer Name\n• Location',
                      onPressed: () {
                        print("Search Button is Pressed");
                        setState(() {
                          _searchIsMap = !_searchIsMap;
                          _filterIsMap = false;
                        });
                        bloc.changeBody((_searchIsMap)
                            ? Center(
                                child: Text("Search Button is Preseed"),
                              )
                            : homeWidget);
                      }),
                  FeatureButton(
                      //custom filters button
                      icon: _filterBtnIcon,
                      titlText: 'Filters',
                      featureId: 'feature2',
                      mainText:
                          'Use this options to filter Pitches. Pitches can be filtered based on:',
                      mainText2: '• category\n• Rating\n• Price',
                      onPressed: () {
                        setState(() {
                          _filterIsMap = !_filterIsMap;
                          _searchIsMap = false;
                        });
                        bloc.changeBody((_filterIsMap)
                            ? Center(
                                child: Text("Filter Button is Preseed"),
                              )
                            : homeWidget);
                      }),
                  FeatureButton(
                    //custom switch button
                    icon: (_listIsMp) ? _mapBtnIcon : _listBtnIcon,
                    titlText: 'Switch View',
                    featureId: 'feature3',
                    mainText:
                        'Tap here to switch between Map View and Lost View to view Pitches close to you.',
                    mainText2: '',
                    onPressed: () {
                      setState(() {
                        _listIsMp = !_listIsMp;
                        _searchIsMap = false;
                        _filterIsMap = false;
                      });
                      bloc.changeBody((_listIsMp)
                          ? Center(
                              child: listWidget(), //listview screen
                            )
                          : homeWidget);
                    },
                  ),
                  SizedBox(width: 12),
                ],
                title: Text(
                  'BEEDYO', //appbar title
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                backgroundColor: Colors.white,
                centerTitle: true,
                automaticallyImplyLeading: false,

                //leading:SvgPicture.asset("images/side_drawer.svg",
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    color: Colors.black,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              drawer: new Drawer(
                //Sidebar navigation
                child: ListView(
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.red[800],
                      ),
                      accountName: new Text('Qasim Abbasi'),
                      accountEmail: new Text('qasimabbasi61@gmail.com'),
                      currentAccountPicture: new CircleAvatar(
                        backgroundImage: new AssetImage('images/qasim.jpg'),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Future<List<Model>> fetchData() async {
    //var list = List<Model>();
    var url = 'https://jsonplaceholder.typicode.com/albums/1/photos';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Model.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load album data from API');
    }
  }

  Widget listWidget() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.isEmpty)
          return Center(
              child:
                  CircularProgressIndicator()); //It will show loader while api data is loaded compeletely
        else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return buildList(_list[index],context);
            },
            itemCount: _list.length,
          );
        }
      },
      future: fetchData(),
    );
  }

  Widget buildList(Model model,dynamic context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 32.0, left: 5.0, bottom: 32.0, right: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                model.thumbnail,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Text(
                model.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // When the user taps the button, navigate to a named route
        // and provide the arguments as an optional parameter.
        Navigator.pushNamed(
          context,
          ListItem.routeName,
          arguments: ListArguments(
            model.title,
            model.url,
          ),
        );
      },
    );
  }
}
