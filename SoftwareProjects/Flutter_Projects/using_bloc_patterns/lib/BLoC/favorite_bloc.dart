import 'dart:async';

import 'package:using_bloc_patterns/BLoC/bloc.dart';
import 'package:using_bloc_patterns/DataLayer/restaurant.dart';

class FavoriteBloc implements Bloc {
  var _restaurants = new List<Restaurant>();
  List<Restaurant> get favorites => _restaurants;

  final _controller = StreamController<List<Restaurant>>.broadcast();
  Stream<List<Restaurant>> get favoritesStream => _controller.stream;

  void toggleRestaurant(Restaurant restaurant) {
    if (_restaurants.contains(restaurant)) {
      _restaurants.remove(restaurant);
    } else {
      _restaurants.add(restaurant);
    }

    _controller.sink.add(_restaurants);
  }

  @override
  void dispose() {
    _controller.close();
  }
}