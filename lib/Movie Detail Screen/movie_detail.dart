import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class MovieDetail extends StatefulWidget {
  late String original_title, description,poster_path,backdrop_path,video,popularity,vote_average;
  late String release_date,id;
  MovieDetail({Key? key, required this.id,required this.original_title,required this.description,required this.poster_path,required this.backdrop_path,required this.video,required this.release_date,required this.popularity,
    required this.vote_average}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState(id,original_title, description,poster_path,backdrop_path,video,release_date,popularity,vote_average);
}

class _MovieDetailState extends State<MovieDetail> {
  String? original_title, description,poster_path,backdrop_path,video,release_date,popularity,vote_average,id;

  _MovieDetailState( this.id,this.original_title,  this.description, this.poster_path, this.backdrop_path, this.video, this.release_date, this.popularity, this.vote_average);
  VideoPlayerController? controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVideoPlayer();
  }
  loadVideoPlayer(){
    controller = VideoPlayerController.network(id!);
    controller?.addListener(() {
      setState(() {});
    });
    controller?.initialize().then((value){
      setState(() {});
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Detail Screen'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 450,
              child: Stack(
                children: [
                  Positioned(child: Container(
                    height: 450,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network('https://image.tmdb.org./t/p/w500'+backdrop_path!, fit: BoxFit.cover,),
                  )),
                  Positioned(bottom: 35,child: Text('⭐ Average Rating - '+ vote_average!,style: GoogleFonts.breeSerif(color: Colors.white,fontSize: 18)),),
                  Positioned(bottom: 10,child: Text('🔥 popularity - '+ popularity!,style: GoogleFonts.breeSerif(color: Colors.white,fontSize: 18)),)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( original_title!,style: GoogleFonts.breeSerif(color: Colors.black,fontSize: 26)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( release_date!,style: GoogleFonts.breeSerif(color: Colors.black,fontSize: 20)),
            ),
            Row(
              children: [
                Flexible(child: Image.network('https://image.tmdb.org./t/p/w500'+poster_path!)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text( description!,style: GoogleFonts.breeSerif(color: Colors.black,fontSize: 18)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
                child: Column(
                    children:[
                      Text('Video Trailer'),
                      AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: VideoPlayer(controller!),
                      ),

                      Container( //duration of video
                        child: Text("Total Duration: " + controller!.value.duration.toString()),
                      ),

                      Container(
                          child: VideoProgressIndicator(
                              controller!,
                              allowScrubbing: true,
                              colors:VideoProgressColors(
                                backgroundColor: Colors.redAccent,
                                playedColor: Colors.green,
                                bufferedColor: Colors.purple,
                              )
                          )
                      ),

                      Container(
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: (){
                                  if(controller!.value.isPlaying){
                                    controller!.pause();
                                  }else{
                                    controller!.play();
                                  }

                                  setState(() {

                                  });
                                },
                                icon:Icon(controller!.value.isPlaying?Icons.pause:Icons.play_arrow)
                            ),

                            IconButton(
                                onPressed: (){
                                  controller!.seekTo(Duration(seconds: 0));

                                  setState(() {

                                  });
                                },
                                icon:Icon(Icons.stop)
                            )
                          ],
                        ),
                      )
                    ]
                )
            ),
          ],
        ),
      ),
    );
  }
}

