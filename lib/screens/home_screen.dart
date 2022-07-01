import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
   const HomeScreen ({Key? key}) : super(key:  key);

   @override
   Widget build (BuildContext context){  
     // ve al árbol de widgets , busca el MoviesProvider y devuelvelo
      final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);   // cuando listen =true . Redibujate cuando haya un cambio 
      //final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);   // cuando se encuentran dentro de un método. para que no se redibuje


      return  Scaffold(
        appBar:  AppBar(
          title: const Text(' Películas en cines') ,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: ()=>showSearch(    // método de búsuqeda
                  context: context, 
                  delegate:  MovieSearchDelegate() 
                  ), 
              icon: const Icon (Icons.search_outlined),
              ),
          ],
          ),
         body: SingleChildScrollView(
           child:Column(  
            children: [
              //tarjetas principales
              CardSwiper(  movies: moviesProvider.onDisplayMovies ),
              //sliders de películas
              MovieSlider( 
                movies: moviesProvider.popularMovies,
                title: 'Populares',
                onNextPage:() => moviesProvider.getPopularMovies(),
              ),
              ],
            ), 
         )
      );
   }
}