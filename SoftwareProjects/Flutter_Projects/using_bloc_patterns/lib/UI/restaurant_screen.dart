import 'package:flutter/material.dart';

import 'package:using_bloc_patterns/BLoC/bloc_provider.dart';
import 'package:using_bloc_patterns/BLoC/restaurant_query_bloc.dart';
import 'package:using_bloc_patterns/DataLayer/location.dart';
import 'package:using_bloc_patterns/DataLayer/restaurant.dart';
import 'package:using_bloc_patterns/UI/favorite_screen.dart';
import 'package:using_bloc_patterns/UI/location_screen.dart';
import 'package:using_bloc_patterns/UI/restaurant_tile.dart';

class RestaurantScreen extends StatelessWidget {
  final Location location;

  const RestaurantScreen({Key key, @required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FavoriteScreen()
              )
            ),
          )
        ],
      ),
      body: _buildSearch(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit_location
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LocationScreen(
              isFullScreenDialog: true,
            ),
            fullscreenDialog: true
          )
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    final bloc = RestaurantQueryBloc(location);

    return BlocProvider<RestaurantQueryBloc>(
      bloc: bloc,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What do you want to eat?'
              ),
              onChanged: (query) => bloc.submitQuery(query)
            )
          ),
          Expanded(
            child: _buildStreamBuilder(bloc)
          )
        ],
      )
    );
  }

  Widget _buildStreamBuilder(RestaurantQueryBloc bloc) {
    return StreamBuilder(
      stream: bloc.restaurantStream,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null) {
          return Center(
            child: Text(
              'Enter a restaurant nameor cuisine type'
            )
          );
        }

        if (results.isEmpty) {
          return Center(
            child: Text(
              'No Results'
            )
          );
        }

        return _buildSearchResults(results);
      } 
    );
  }

  Widget _buildSearchResults(List<Restaurant> results) {
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final restaurant = results[index];
        return RestaurantTile(
          restaurant: restaurant,
        );
      },
    );
  }
}