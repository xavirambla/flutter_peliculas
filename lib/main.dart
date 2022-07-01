import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/screens.dart';
import 'package:provider/provider.dart';


void main() {
//  runApp(const MyApp());
  runApp(const AppState());  
}


class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
//          create: ( _ ) => MoviesProvider()  // se crea de manera perezosa. Solo se creará cuando se necesite.
          create: ( _ ) => MoviesProvider(),lazy: false,  // se crea al principio cuando se asigna.
          )
      ],
      child: MyApp(),
      );
  }


}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peliculas',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes:{
        'home': ( _ ) =>  HomeScreen(),
        'details': ( _ ) =>  DetailsScreen(),
      }     ,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.indigo,
           )
      ),

    );
  }
}

