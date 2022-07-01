
// Permite crear un mapa o una clase 
//https://quicktype.io/
// pegamos el contenido del json
//mano derecha cambiar a lenguaje dart.
// Activar Put encoder y decoder  in class
//Activar use method names from Map () & toMap()

// hay que retocar  el código para arreglar los errores .
//F2 y Cambiar el class Result por class Movie.


// To parse this JSON data, do
//
//     final nowPlayingResponse = nowPlayingResponseFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas/models/models.dart';

class NowPlayingResponse {

    NowPlayingResponse({
        required this.dates,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    Dates dates;
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

   // factory constructor . Crea una instancia en base al json recibido. 
    factory NowPlayingResponse.fromJson(String str) => NowPlayingResponse.fromMap(json.decode(str));

    // coge toda la instancia de la clase y crea un mapa // no lo utilizaremos
//    String toJson() => json.encode(toMap());

// factory constructor. recibe un mapa  y crea instancias de movies en base a l list que se recibe
    factory NowPlayingResponse.fromMap(Map<String, dynamic> json) => NowPlayingResponse(
        dates           : Dates.fromMap(json["dates"]),
        page            : json["page"],
        results         : List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages      : json["total_pages"],
        totalResults    : json["total_results"],
    );
/*
no vamos a usarlo
    Map<String, dynamic> toMap() => {
        "dates": dates.toMap(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };*/
}

class Dates {
    Dates({
        required this.maximum,
        required this.minimum,
    });

    DateTime maximum;
    DateTime minimum;

    factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));

/* no lo usaremos
    String toJson() => json.encode(toMap());
*/

    factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );

/*
no lo usaremos
    Map<String, dynamic> toMap() => {
        "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
    };
    */
}

