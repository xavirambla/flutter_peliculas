

import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title ;
  final Function onNextPage;

   const MovieSlider ({
     Key? key,
      required this.movies, 
      required this.onNextPage     ,
      this.title
      
     }) : super(key:  key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  
  final ScrollController scrollController = new ScrollController();
  
  @override
  void initState() {
      //ejecuta el código la primera vez que se crea
    super.initState();
   
    scrollController.addListener(() {
      if ( scrollController.position.pixels>= scrollController.position.maxScrollExtent-500 ){
    //    print("obtener siguiente pagina");
        widget.onNextPage();

      }
      /*
      print( scrollController.position.pixels);      
      print( scrollController.position.maxScrollExtent);
      */

    });

  }

  @override
  void dispose() {
    // ejecuta el código cuando el objeto va a ser destruído.
    super.dispose();
  }

  
   @override
   Widget build (BuildContext context) {
      return  Container(
        width: double.infinity,
        height: 260,
  //      color:Colors.red ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.title!=null)       Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold) ),
              ),
              const SizedBox(height: 5,),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.movies.length,                
                  itemBuilder: ( _ ,int index)=>_MoviePoster( movie: widget.movies[index] , heroId: '${widget.title}-$index-${widget.movies[index].id}', ),
                  /*
                  itemBuilder: ( _ ,int index) {
                    return  _MoviePoster();
                  },
                  */
                  ),
              )
            
          ],)

         
      );
  }
}


class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;

  const _MoviePoster({
    Key? key, 
    required this.movie, 
    required this.heroId

    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;
    return Container(
                      width: 130,
                      height: 190,
//                      color: Colors.green,
                      margin:const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, 'details',arguments: movie ),
                            child: Hero(
                              tag: movie.heroId!,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FadeInImage(
                                  placeholder: const AssetImage('assets/no-image.jpg'), 
                                  image: NetworkImage( movie.fullPosterImg ),
                                  width: 130,
                                  height: 190,
                                  fit: BoxFit.cover,                            
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            movie.title,
                            overflow: TextOverflow.ellipsis,  // para que ponga ... si no hay sitio
                            maxLines:2,
                            textAlign: TextAlign.center,
                            )
                        ]
                        ,)
                      
                      );
  }
}
