

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';



class MoviesProvider extends ChangeNotifier{
  
  final String _baseUrl   =  'api.themoviedb.org';
  final String _apiKey    = 'd98393c0f0af00970241bc8b08ba69dc';
  final String _language  = 'es-ES';

  List<Movie> onDisplayMovies =[];
  List<Movie> popularMovies =[];

  Map<int, List<Cast>> moviesCast = {};  // Guardaremos los actores de las películas en memoria para no tener que ir a buscarlos cuando se pregunten por segunda vez.
  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream =>_suggestionStreamController.stream;
  



  MoviesProvider(){
    print('Movies provider inicializado');
    getOnDisplayMovies();
    getPopularMovies( );
    print('FIN Movies provider inicializado');

  }

  Future<String> _getJsonData( String endPoint, [int page=1] ) async{
    final url= Uri.https( _baseUrl , endPoint   ,   {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '$page'
    }    );
      final response = await http.get(url);
      return response.body;

  }

  getOnDisplayMovies() async{
    /*
    var url= Uri.https( _baseUrl ,'3/movie/now_playing'   ,   {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '1'
    }    );
    final response = await http.get(url);
    // le decimos cómo debe recoger los valores 
//    final decodedData = json.decode(response.body) as Map<String,dynamic>;
 //   final Map<String,dynamic> decodedData = json.decode(response.body) ;  // las dos líneas hacen lo mismo
    final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
    */
    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    //print ( nowPlayingResponse.results[1].title);   // se recomienda mapear así
    onDisplayMovies = nowPlayingResponse.results; 
    notifyListeners(); // le dice a todos los widgets que estén escuchando que se ha modificado un valor.
  }

  getPopularMovies( ) async{    
    /*
    var url= Uri.https( _baseUrl ,'3/movie/popular'   ,   {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '1'
    }    );
    final response = await http.get(url);
    final popularResponse = PopularResponse.fromJson(response.body);
*/
    _popularPage++;  // cada vez que nos llame, pediremos buscar la siguiente pagina
    final jsonData = await _getJsonData( '3/movie/popular' , _popularPage );
    final popularResponse = PopularResponse.fromJson( jsonData );
    popularMovies = [...popularMovies, ...popularResponse.results];   // lo vamo s a desestructurar pq lo llamaremos varias veces para cambiar de página (y no queremos perder los viejos)
    // pon las viejas peliculas y añade las nuevas.
//    print (popularMovies[0]);
    notifyListeners(); 
 }

  Future<List<Cast>> getMovieCast( int movieId) async {
  //revisar el mapa

 //  en caso de tener el mapa en memoria , no hace falta recuperar los datos de nuevo del servidor.
  if (moviesCast.containsKey(movieId))
      return moviesCast[movieId]!;

//  print('pidiendo info al servidor -Cast');
  final jsonData = await _getJsonData( '3/movie/$movieId/credits');
  final creditsResponse = CreditsResponse.fromJson( jsonData );

  moviesCast[movieId] = creditsResponse.cast;

  return creditsResponse.cast;
}


Future<List<Movie>> searchMovies ( String query ) async{
      final url= Uri.https( _baseUrl , '3/search/movie'   ,   {
      'api_key' : _apiKey,
      'language' : _language,
      'query': query

      } );
      final response = await http.get(url);
      final searchResponse = SearchResponse.fromJson ( response.body );
      return searchResponse.results;
}

  void getSuggestionByQuery( String searchTerm){
    // emita el valor hasta que la persona deja de escribir
    debouncer.value='';
   debouncer.onValue = ( value) async {
     print('Tenemos Valor a buscar: $value');
     final results =await this.searchMovies(value);
     _suggestionStreamController.add( results );
   };

  final timer =Timer.periodic( const Duration(milliseconds: 300), ( _) {
      debouncer.value=searchTerm;
   });

  Future.delayed( const Duration(milliseconds: 301)).then( ( _ ) =>timer.cancel()  )  ;

} 


}