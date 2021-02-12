
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProviders {
  
  String _apiKey = 'a8f001f4fc1ca1ba68ab9880bd251994';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  final _popularesStreamControler = new StreamController<List<Pelicula>>.broadcast(); // brodcast es para que mas de una persona pueda escuchar la emisión del stream.

  Function(List<Pelicula>) get popularesSink => _popularesStreamControler.sink.add;

  Stream <List<Pelicula>> get popularesStream  => _popularesStreamControler.stream;


  // para destruir los Streams cuando se dejan de usar.
  void disposeStreams() {

    _popularesStreamControler?.close();

  }


  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
          // instalar flutter http en pubsepec.yaml

      final resp = await http.get( url);
      final decodeData = json.decode(resp.body);  // trasnforma la respuesta en un mapa.
      final peliculas = new Peliculas.fromJsonList(decodeData['results']); // barre todo el decode creando peliculas para cada resultado.


      return peliculas.items; // lista de peliculas
  }

  Future<List<Pelicula>>getEnCines() async {

      final url = Uri.https(_url, '3/movie/now_playing', {
        'api_key'  : _apiKey,
        'language' : _language
      });

      return await _procesarRespuesta(url);

  }

    Future<List<Pelicula>>getPopulares() async {

      
      _popularesPage ++;

      final url = Uri.https(_url, '3/movie/popular', {
        'api_key'  : _apiKey,
        'language' : _language,
        'page': _popularesPage.toString()
      });

      final resp = await _procesarRespuesta(url);
      _populares.addAll( resp ); // agrega toda la respuesta
      popularesSink(_populares);

      return resp;

  }


}