import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculas/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

   const CardSwiper ({
     Key? key, 
     required this.movies
     }) : super(key:  key);

   @override
   Widget build (BuildContext context){  
      final size = MediaQuery.of(context).size;

      if (movies.length == 0) {
        return Container(
          width: double.infinity,
          height: size.height*0.5 ,
          child: const  Center(child: CircularProgressIndicator())) ;
        
      }


      return Container(
        width: double.infinity,
        height: size.height*0.5,   //queda un poco más abajo de la mitad por culpa del appBar,
//        color: Colors.red,
        child:Swiper(
          itemCount: movies.length,
          layout: SwiperLayout.STACK,
          itemWidth: size.width*0.6,
          itemHeight: size.height*0.4,
//          itemBuilder: ( _ ,int index){  
          itemBuilder: ( _ ,int index){
            final movie= movies[index];
    //        print(movie.posterPath);
      //      print(movie.fullPosterImg);
            movie.heroId = 'swiper-${movie.id}';
            // devuelve un widget para devolver las tarjetas
            return GestureDetector(
              onTap:() =>Navigator.pushNamed(context,'details',arguments: movie ),   //cuando clique realice algo
              child: Hero(    //anima la transición de imagenes  HeroAnimator
                tag: movie.heroId! ,   // debe ser único en todo el widget
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:   FadeInImage(
                    placeholder:  const AssetImage( 'assets/no-image.jpg' ) , 
                    image:  NetworkImage( movie.fullPosterImg),
                    fit: BoxFit.cover,   // adaptar la imágen al espacio que tiene el widget
                  )
                ),
              ),
            );
            
          } ,    // algo que se construye de manera dinámica
          )
      );
   }

}