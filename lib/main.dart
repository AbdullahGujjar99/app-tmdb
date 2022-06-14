import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'Movie Detail Screen/movie_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Fix',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home:Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String apikey = 'ce8282963fbe3cd6523f456a186ccf1e';
  final token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjZTgyODI5NjNmYmUzY2Q2NTIzZjQ1NmExODZjY2YxZSIsInN1YiI6IjYyYTIyZjY4Y2Y0YTY0MDA5ZmEyMzRjOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ko5LjZ15OahxCKl4U_4hkyhuJQmROZe8P6-11sXsYYE';
  List upcomingmovies = [];

  initState(){
    super.initState();
    loadmovies();
  }
  loadmovies()async{
    TMDB tmdbMovies = TMDB(ApiKeys(apikey, token),
    logConfig: ConfigLogger(
        showLogs: true,
      showErrorLogs: true,
    ));
    Map upcomingresult = await tmdbMovies.v3.movies.getUpcoming();
    setState(() {
      upcomingmovies = upcomingresult['results'];
    });
    print('JFKJKGknfknkfkgkf');
    print(upcomingmovies);
  }
  getVideo(int id)async{
    TMDB tmdbMovies = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(
          showLogs: true,
          showErrorLogs: true,
        ));
    Map videoresult = await tmdbMovies.v3.movies.getVideos(id);
    print(videoresult);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Movie App'
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30,),
          CupertinoSearchTextField(
            onChanged: (String value) {
              print('The text has changed to: $value');
            },
            onSubmitted: (String value) {
              print('Submitted text: $value');
            },
          ),
              SizedBox(height: 10,),
              Text('Upcoming Movies',  style: GoogleFonts.breeSerif(color: Colors.black,fontSize: 26),),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height,
                //height: 350,
                child: ListView.builder(itemCount: upcomingmovies.length,
                    //scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      getVideo(upcomingmovies[index]['id']);
                      print('https://api.themoviedb.org/3/movie/297762/videos?api_key= $apikey');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieDetail(
                        id: 'https://api.themoviedb.org/3/movie/${upcomingmovies[index]['id'].toString()}/videos?api_key= $apikey',
                        original_title: upcomingmovies[index]['original_title'], description: upcomingmovies[index]['overview'],
                        poster_path: upcomingmovies[index]['poster_path'],backdrop_path:upcomingmovies[index]['backdrop_path'],
                        video: upcomingmovies[index]['video'].toString(),release_date: upcomingmovies[index]['release_date'],vote_average:upcomingmovies[index]['vote_average'].toString(), popularity: upcomingmovies[index]['popularity'].toString(),
                      )));
                    },
                    child: Container(
                      //width: MediaQuery.of(context).size.width,
                      width: 200,
                      child: Column(
                        children: [
                          Container(height: 200,
                            decoration: BoxDecoration(image: DecorationImage(
                              image: NetworkImage(
                                'https://image.tmdb.org./t/p/w500'+upcomingmovies[index]['poster_path']
                              )
                            )),
                          ),
                          Text('${upcomingmovies[index]['original_title']!= null? upcomingmovies[index]['original_title']: 'No Name'}',
                            style: GoogleFonts.breeSerif(color: Colors.black,fontSize: 18),),
                          SizedBox(height: 15,),

                        ],
                      ),
                    ),

                  );
                }),
              ),
              ElevatedButton(onPressed: (){
                loadmovies();
              }, child: Text('movies'))
            ],
          ),
        ),
      ),
    );
  }
}

