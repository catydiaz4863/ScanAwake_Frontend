import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/screens/basic_alarm.dart';
import 'package:scanawake/screens/loadingscreen.dart';
import 'package:provider/provider.dart';
import 'screens/loginscreen.dart';
import 'screens/mainscreen.dart';
import 'screens/_test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = AppBloc();
    return ChangeNotifierProvider(
      builder: (_) => bloc,
      child: MaterialApp(
        showSemanticsDebugger: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(elevation: 0),
          primarySwatch: Colors.blue,
        ),
        home: SetupWidget(),
      ),
    );
  }
}

class SetupWidget extends StatefulWidget {
  SetupWidget({Key key}) : super(key: key);

  @override
  _SetupWidgetState createState() => _SetupWidgetState();
}

class _SetupWidgetState extends State<SetupWidget> {
  Widget _buildScreen(AppBloc bloc) {
    /* Testing Componenets/Asset Purposes */
    return BasicAlarm();
    //return MainScreen();

    if (bloc.isLoggedIn) {
      if (bloc.isReady) {
        return MainScreen();
      } else {
        return LoadingScreen();
      }
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);

    return  _buildScreen(bloc);
  }
}
