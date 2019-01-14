import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

@immutable
class AppState {
  final int counter;
  AppState(this.counter);
}

enum Actions { Increment }

AppState reducer(AppState prev, action) {
  if (action == Actions.Increment) {
    return AppState(prev.counter + 1);
  }
  return prev;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Redux Sample',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  final Store<AppState> store = Store(reducer, initialState: AppState(0));

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: Scaffold(
          appBar: AppBar(title: Text('Flutter Redux')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Number of times you pressed the button:'),
                StoreConnector(
                    converter: (Store<AppState> store) => store.state.counter,
                    builder: (context, counter) => Text('$counter',
                        style: Theme.of(context).textTheme.display1))
              ],
            ),
          ),
          floatingActionButton: StoreConnector(
            converter: (Store<AppState> store) {
              return () => store.dispatch(Actions.Increment);
            },
            builder: (context, callback) => FloatingActionButton(
                  onPressed: callback,
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
          ),
        ));
  }
}

void main() => runApp(MyApp());
