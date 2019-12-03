import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/screens/create_basic_alarm.dart';
import 'package:scanawake/screens/disable_alarm.dart';
import 'package:scanawake/screens/loadingscreen.dart';
import 'package:provider/provider.dart';
import 'models/alarm.dart';
import 'screens/mainscreen.dart';
import 'screens/_test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
    final GlobalKey<NavigatorState> navigatorKey =
        new GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = AppBloc();

    return ChangeNotifierProvider(
      builder: (_) => bloc,
      child: MaterialApp(
      //  navigatorKey: navigatorKey,
        onGenerateRoute: (settings) {
          // If you push the PassArguments route
          if (settings.name == DisableScreen.routeName) {
            // Cast the arguments to the correct type: ScreenArguments.
            final Alarm args = settings.arguments;

            // Then, extract the required data from the arguments and
            // pass the data to the correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return DisableScreen(
                  args,
                );
              },
            );
          }
        },
        showSemanticsDebugger: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(elevation: 0),
          primarySwatch: Colors.purple,
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
    // return CreateBasicAlarm();

    return MainScreen();
    /*
      if (bloc.isReady) {
        return MainScreen();
      } else {
        return LoadingScreen();
      }
      */
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);

    return _buildScreen(bloc);
  }
}
