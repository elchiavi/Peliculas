import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_providers.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculasProviders = new PeliculasProviders();

  @override
  Widget build(BuildContext context) {

    peliculasProviders.getPopulares(); // me traigo el listado de peliculas y ejecuta el popularesSink.

    return Scaffold(
      appBar: AppBar(
        title: Text('Últimas Películas'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),

        ],
      ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // espacio entre elementos
            children: <Widget> [
                _swiperTarjetas(),
                _footer(context),
            ],
          ),
        ) 
    );
    
  }

  Widget _swiperTarjetas() {

      return FutureBuilder(
        future: peliculasProviders.getEnCines(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

          if (snapshot.hasData) { // si tiene info 
              return CardSwiper( peliculas: snapshot.data);
          } else { // sino loading...
              return Container(
                height: 400.0,
                child: Center(
                  child: CircularProgressIndicator()
                ),
                
              );
          }
        },
      );

  }

  Widget _footer(BuildContext context) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Más Populares', style: Theme.of(context).textTheme.subtitle1,)),
          SizedBox(height: 5.0,),

          StreamBuilder(
            stream: peliculasProviders.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if( snapshot.hasData) {
                  return MovieHorizontal(peliculas: snapshot.data, siguientePagina: peliculasProviders.getPopulares); // sin los parentesis getpopulares solo la definición
              } else {
                return Center(
                  child: CircularProgressIndicator());
              }   
              
            },
          ), 
        ],
      ),

    );
  }
}