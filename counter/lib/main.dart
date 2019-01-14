import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

enum Actions { Increment, Decrement }

@immutable
class AppState {
  final int counter;
  AppState(this.counter);

  bool isDecrementable() {
    return counter > 0;
  }
}

AppState counterReducer(AppState prev, dynamic action) {
  if (action == Actions.Increment) {
    return AppState(prev.counter + 1);
  }

  if (action == Actions.Decrement) {
    if (prev.counter == 0) {
      return prev;
    }
    return AppState(prev.counter - 1);
  }

  return prev;
}

void middleware(Store<AppState> store, action, NextDispatcher next) {
  if (action == Actions.Increment) {
    print(
        'current count is ${store.state.counter}, and going to be incremented.');
  } else if (action == Actions.Decrement) {
    print(
        'current count is ${store.state.counter}, and going to be decremented.');
  }

  next(action);

  if (action == Actions.Increment) {
    print('current count is updated: ${store.state.counter}');
  }
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
  final Store<AppState> store = Store(counterReducer,
      initialState: AppState(0), middleware: [middleware]);

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
                _buildCounterLabel(context),
                _buildIncrementButton(context),
                _buildDecrementButton(context)
              ],
            ),
          ),
        ));
  }

  Widget _buildCounterLabel(BuildContext context) {
    return StoreConnector<AppState, int>(
        converter: (Store<AppState> store) => store.state.counter,
        builder: (context, counter) =>
            Text('$counter', style: Theme.of(context).textTheme.display1));
  }

  Widget _buildIncrementButton(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
        converter: (Store<AppState> store) {
      return () => store.dispatch(Actions.Increment);
    }, builder: (context, callback) {
      return RaisedButton(child: Icon(Icons.add), onPressed: callback);
    });
  }

  Widget _buildDecrementButton(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
        converter: (Store<AppState> store) {
      return () => store.dispatch(Actions.Decrement);
    }, builder: (context, callback) {
      bool isDecrementable = store.state.isDecrementable();
      return RaisedButton(
        child: Icon(Icons.remove),
        onPressed: (isDecrementable) ? callback : null,
      );
    });
  }
}

void main() => runApp(MyApp());
