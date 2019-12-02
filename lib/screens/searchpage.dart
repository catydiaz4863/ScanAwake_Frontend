import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);

    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("ScanAwake"),
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: bloc.titles.length,
                  itemBuilder: (BuildContext ctxt, int i) {
                    return ListTile(
                      title: Text(bloc.titles[i]),
                      onTap: () {
                        bloc.chosenTitle = bloc.titles[i];
                        bloc.chosenURL = bloc.urls[i];
                        Navigator.pop(context);
                      },
                    );
                  }),
            ),
          ])),
    );
  }
}