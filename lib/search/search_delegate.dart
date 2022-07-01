

import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {

  //@override
  String get searchDelegate => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    //throw UnimplementedError();
    return [
      IconButton(
        onPressed: (){
          query='';   // quita el texto de buscar cuando se pulsa
        },
       icon: const Icon (Icons.clear )
       )
      
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    //throw UnimplementedError();
    return IconButton(
      icon: const Icon (Icons.arrow_back),
      onPressed : () {
        close(context, null);   // volvemos a la pantalla anterior y no devolvemos ningún valor
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
//    throw UnimplementedError();
return  Text('buildResults');
  }


  Widget _EmptyContainer(){
    return  Container(
        child: const  Center(
          child: Icon ( Icons.movie_creation , color: Colors.black38, size:130,),)
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {    
    //throw UnimplementedError();
    if (query.isEmpty){
      return  Container(
        child: const  Center(
          child: Icon ( Icons.movie_creation , color: Colors.black38, size:130,),)
        );
    }
    print('http request');

    final moviesProvider = Provider.of<MoviesProvider>(context , listen : false);
    moviesProvider.getSuggestionByQuery(query);  //se llamará cada vez que el usuario toque una tecla

    return StreamBuilder(
      stream: moviesProvider.suggestionsStream,
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
        if (! snapshot.hasData)  return  _EmptyContainer();

        final movies = snapshot.data;

        return ListView.builder(
          itemCount: movies!.length,
          itemBuilder: ( _ , int index) =>  _MovieItem( movie: movies[index] ),

          );
        
      },
    );
/*
    return FutureBuilder(
      future: moviesProvider.searchMovie( query ),
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
        if (! snapshot.hasData)  return  _EmptyContainer();

        final movies = snapshot.data;

        return ListView.builder(
          itemCount: movies!.length,
          itemBuilder: ( _ , int index) =>  _MovieItem( movie: movies[index] ),

          );
        
      },
    );
*/
    
  }


}






class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({
    Key? key, 
    required this.movie
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'), 
          image: NetworkImage( movie.fullPosterImg   ),
          width:50,
          fit: BoxFit.contain   ,
           ),
      ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () {
          print(movie.title);
          Navigator.pushNamed(context, 'details' , arguments:movie );
        }
      );
  }
}




