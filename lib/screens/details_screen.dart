
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
   const DetailsScreen ({Key? key}) : super(key:  key);
   
   @override
   Widget build (BuildContext context){  
// Todo : Cambiar luego por una instancia de movie
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie; // leer los argumentos   , el interrogante es pq igual no me llegan argumentos


      return  Scaffold(
        
         body: CustomScrollView(   // scrooll pero preparado  slivers  . Sllivers widgets que tienen cierto comportamiento preprogramado cuando se realiza scroll en el comportamiento del padre
           slivers:[
              _CustomAppBar( movie:movie ),
             SliverList(
               delegate: SliverChildListDelegate(
                 [
                   _PosterAndTitle( movie:movie ),
                   _Overview( movie:movie ),
                    CastingCards( movieId: movie.id ),
                 ]
                 ),
             )
           ]
           )

      );
   }
}

class _CustomAppBar extends StatelessWidget {
   final Movie movie;

  const _CustomAppBar({
    Key? key, 
       required this.movie }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true, //nunca desaparece el widget
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const  EdgeInsets.all(0),   // quitamos el padding que se había creado
        title: Container(
           width: double.infinity,
           alignment: Alignment.bottomCenter,
           padding: const EdgeInsets.only(bottom: 10 , left:10, right:10),
           color:Colors.black12,
           child: Text(
             movie.title,
             style: const TextStyle(fontSize: 16),
             textAlign: TextAlign.center,
             ) ,
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.fullPosterImg),
          fit:BoxFit.cover,  // para que se expanda todo lo que pueda sin perder las dimensiones de la imágen
          ),
        ),
      
      );
  }
}


class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({
    Key? key, 
    required this.movie
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  TextTheme textTheme  =  Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size; 

    return Container(
      margin: const EdgeInsets.only(top:20),   //separación con elementos externos
      padding:const EdgeInsets.symmetric(horizontal: 20),   //separación con elementos internos
      child: Row(
          children: [
            Hero(
              tag:movie.heroId!,  // es el mismo tag del widget de donde proviene
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage ( movie.fullPosterImg ),
                  height: 150,
            //                width: 110,
                  ),
              ),
            ),
            const SizedBox(width: 20, ),

            ConstrainedBox(   // el Constrain se pone para limitar los espacios ya quye sino sobrepasaba los límites cuadno el título era demasiado largo.
              constraints: BoxConstraints(maxWidth: size.width -190),
              child: Column(
                children: [
                  Text(movie.title, style: textTheme.headline5 ,overflow: TextOverflow.ellipsis, maxLines: 2,),
                  Text( movie.originalTitle , style: textTheme.subtitle1 ,overflow: TextOverflow.ellipsis, maxLines: 3,),
                  Row(
                    children: [
                    const Icon(Icons.star_outline, size:15, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text('${movie.voteAverage}',style: textTheme.caption)
                  ]
                  ,)

                ],)

            ),


/*
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width -190),
                  child: Text(movie.title, style: textTheme.headline5 ,overflow: TextOverflow.ellipsis, maxLines: 2,),
                  ),
                
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width -190),
                  child: Text( movie.originalTitle , style: textTheme.subtitle1 ,overflow: TextOverflow.ellipsis, maxLines: 1,)),
                Row(
                  children: [
                    Icon(Icons.star_outline, size:15, color: Colors.grey),
                    SizedBox(width: 5),
                    Text('${movie.voteAverage}',style: textTheme.caption)
                  ]
                  ,)
              
              ],
              )
              */
          ],
      )  
    );
  }
   
}




class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({
    Key? key, 
    required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:30,vertical: 10),
      child: Text( movie.overview ,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}