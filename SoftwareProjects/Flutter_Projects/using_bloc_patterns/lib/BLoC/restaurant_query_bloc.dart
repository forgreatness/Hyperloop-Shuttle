import 'dart:async';

import 'package:using_bloc_patterns/BLoC/bloc.dart';
import 'package:using_bloc_patterns/DataLayer/location.dart';
import 'package:using_bloc_patterns/DataLayer/restaurant.dart';
import 'package:using_bloc_patterns/DataLayer/zomato_client.dart';

class RestaurantQueryBloc implements Bloc {
  final Location location;
  final _client = ZomatoClient();
  final _controller = StreamController<List<Restaurant>>();
  Stream<List<Restaurant>> get restaurantStream => _controller.stream;

  RestaurantQueryBloc(this.location);

  void submitQuery(String query) async {
    final results = await _client.fetchRestaurants(location, query);
    _controller.sink.add(results);
  }

  @override
  void dispose() {
    _controller.close();
  }
}