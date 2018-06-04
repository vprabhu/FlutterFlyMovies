import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:movies_flutter/data/upcomingmovies.dart';
import 'package:movies_flutter/utils/constants.dart';
import 'package:movies_flutter/anim/details_animator.dart';

class GridHomePage extends StatefulWidget {
  @override
  _GridHomePageState createState() => new _GridHomePageState();
}

class _GridHomePageState extends State<GridHomePage> with SingleTickerProviderStateMixin {

  String _indicatorString = "Upcoming";

  double containerOneOpacity = 1.0;
  double containerTwoOpacity = 0.4;
  double containerThreeOpacity = 0.4;

  TabController _tabController;

  var upcomingMoviesList = new List<UpcomingMovies>();
  var nowPlayingList = new List<UpcomingMovies>();
  var topRatedList = new List<UpcomingMovies>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: Drawer(
              elevation: 50.0,
              child: new ListView(
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  DrawerHeader(
                      decoration: BoxDecoration(color: Colors.black54),
                      child: Column(
                        children: <Widget>[
                          Text("Header" , style: TextStyle(color: Colors.white),),
                          SizedBox(width: 0.0 , height: 10.0,),
                          CircleAvatar(backgroundImage: NetworkImage("https://cdn-images-1.medium.com/max/1000/1*xC_TLYcq5MO4VGAPgPDqHg.png" ), radius: 36.0,
                          ),
                        ],
                      ) ),
                  ListTile(title: Text("Movies") , onTap: (){},),
                  ListTile(title: Text("Tv Shows"), onTap: (){},),
                  ListTile(title: Text("Watchlist"), onTap: (){},),
                  ListTile(title: Text("Rate us"), onTap: (){},),
                ],
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverList(
                    delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return _returnColumn();
                      },
                      childCount: 1 ,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildGridView(upcomingMoviesList),
                  _buildGridView(nowPlayingList),
                  _buildGridView(topRatedList),
                ],
              ),
            ),
          ),
        )
    );
  }

  @override
  void initState(){
    super.initState();
    this.fetchUpcomingMovies();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    this.setState(() {
      changeIndicator(_tabController.index);
    });
  }

  void changeIndicator(int indicatorIndex){
    switch(indicatorIndex){
      case 0 :
        _indicatorString = "UpComing";
        containerOneOpacity =1.0;
        containerTwoOpacity =0.4;
        containerThreeOpacity =0.4;
        break;
      case 1 :{
        this.fetchNowPlayingMovies();
        _indicatorString = "In theatres";
        containerOneOpacity =0.4;
        containerTwoOpacity =1.0;
        containerThreeOpacity =0.4;
      }break;
      case 2 :{
        this.fetchTopRatedMovies();
        _indicatorString = "Top Rated";
        containerOneOpacity =0.4;
        containerTwoOpacity =0.4;
        containerThreeOpacity =1.0;
      }break;

    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Future<List<UpcomingMovies>> fetchUpcomingMovies() async{
    final response = await http.get(BASE_URL + UPCOMING_MOVIES +"?api_key="+API_KEY+"&page=1");
    var responseJson = json.decode(response.body.toString());
    this.setState((){
      upcomingMoviesList = parseUpcomingMoviesJson(responseJson["results"]);
    });
    return upcomingMoviesList;
  }

  Future<List<UpcomingMovies>> fetchNowPlayingMovies() async{
    final response = await http.get(BASE_URL + NOW_PLAYING +"?api_key="+API_KEY+"&language=en-US&page=1");
    var responseJson = json.decode(response.body.toString());
    this.setState((){
      nowPlayingList = parseUpcomingMoviesJson(responseJson["results"]);
    });
    return nowPlayingList;
  }

  Future<List<UpcomingMovies>> fetchTopRatedMovies() async{
    final response = await http.get(BASE_URL + TOP_RATED +"?api_key="+API_KEY+"&language=en-US&page=1");
    var responseJson = json.decode(response.body.toString());
    this.setState((){
      topRatedList = parseUpcomingMoviesJson(responseJson["results"]);
    });
    return topRatedList;
  }

  List<UpcomingMovies> parseUpcomingMoviesJson(var upcomingMoviesJson){
    List<UpcomingMovies> moviesTempList = new List();
    for(int i = 0 ; i< upcomingMoviesJson.length ; i++ ){
      String image = upcomingMoviesJson[i]["poster_path"];
      String title = upcomingMoviesJson[i]["title"];
      String overview = upcomingMoviesJson[i]["overview"];
      String voteAverage = upcomingMoviesJson[i]["vote_average"].toString();
      var upcomingMovies = new UpcomingMovies(image , title , overview , voteAverage);
      moviesTempList.add(upcomingMovies);
    }
    return moviesTempList;
  }

  Widget _buildGridView(List<UpcomingMovies> moviesList){
    return Center(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context , int){
          print(moviesList[int].title);
          return GestureDetector(
            onTap: (){
              launchDetails(context, moviesList[int]);
//                Scaffold.of(context).showSnackBar(SnackBar(content: Text(snapshot.data[int].title)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:  MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: moviesList[int].title,
                  child: Card(
                    child: Image.network(IMAGE_BASE_URL + moviesList[int].posterPath ,
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.fitWidth,),
                    elevation: 30.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  ),
                ),
                Center(child: Text(moviesList[int].title, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white,
                fontFamily: 'Montserrat',fontSize: 14.0),),),
              ],
            ),
          );
        },itemCount: moviesList.length==0 ? 0 : moviesList.length ,
      ),
    );

  }

  Widget _returnColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 38.0,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(_indicatorString ,
            style: TextStyle(fontWeight: FontWeight.bold ,
                fontSize: 18.0
                ,color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width : 5.0,),
            _returnContainer(containerOneOpacity),
            SizedBox(width: 5.0,),
            _returnContainer(containerTwoOpacity),
            SizedBox(width: 5.0,),
            _returnContainer(containerThreeOpacity),
          ],
        ),
      ],
    );
  }

  Widget _returnContainer(double opacityValue){
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      color: Colors.white.withOpacity(opacityValue),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      width: 30.0,
      height: 2.5,
    );
  }

  void launchDetails(BuildContext context , UpcomingMovies name){
    Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context){
        return DetailsAnimator(name);
      },
    ));
  }
}


/*class GridHomePage  extends StatelessWidget {


   @override
   Widget build(BuildContext context) {
     return Scaffold(
         body: DefaultTabController(
           child: Scaffold(
             drawer: Drawer(
               elevation: 50.0,
               child: new ListView(
                 padding: EdgeInsets.all(8.0),
                 children: <Widget>[
                   DrawerHeader(
                       decoration: BoxDecoration(color: Colors.black54),
                       child: Column(
                         children: <Widget>[
                           Text("Header" , style: TextStyle(color: Colors.white),),
                           SizedBox(width: 0.0 , height: 10.0,),
                           CircleAvatar(backgroundImage: NetworkImage("https://cdn-images-1.medium.com/max/1000/1*xC_TLYcq5MO4VGAPgPDqHg.png" ), radius: 36.0,
                           ),
                         ],
                       ) ),
                   ListTile(title: Text("Movies") , onTap: (){},),
                   ListTile(title: Text("Tv Shows"), onTap: (){},),
                   ListTile(title: Text("Watchlist"), onTap: (){},),
                   ListTile(title: Text("Rate us"), onTap: (){},),
                 ],
               ),
             ),
             body: NestedScrollView(
               headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                 return <Widget>[
                   new SliverAppBar(
                     title: Text("Movies"),
                     elevation: 0.0,
                     actions: <Widget>[
                       IconButton(icon: Icon(Icons.search), onPressed: (){}) ,
                       IconButton(icon: Icon(Icons.add_box), onPressed: (){}) ,
                     ],
                     pinned: true,
                     expandedHeight: 50.0,
                     floating: false,
                   ),
                 ];
               },
               body: TabBarView(
                 children: <Widget>[
                   _buildGridView(),
                 ],
               ),
             ),
           ),
           length: 0,
         )
     );
   }

  Future<List<UpcomingMovies>> fetchUpcomingMovies() async{
    final response = await http.get(BASE_URL + UPCOMING_MOVIES +"?api_key="+API_KEY+"&page=1");
    var responseJson = json.decode(response.body.toString());
    return parseUpcomingMoviesJson(responseJson["results"]);
  }

  List<UpcomingMovies> parseUpcomingMoviesJson(var upcomingMoviesJson){
    List<UpcomingMovies> mUpcomingMoviesTempList = new List();
    for(int i = 0 ; i< upcomingMoviesJson.length ; i++ ){
      String image = upcomingMoviesJson[i]["poster_path"];
      String title = upcomingMoviesJson[i]["title"];
      String overview = upcomingMoviesJson[i]["overview"];
      String voteAverage = upcomingMoviesJson[i]["vote_average"].toString();
      var upcomingMovies = new UpcomingMovies(image , title , overview , voteAverage);
      mUpcomingMoviesTempList.add(upcomingMovies);
    }
    return mUpcomingMoviesTempList;
  }

  Widget _buildGridView(){
    return Center(
      child: FutureBuilder<List<UpcomingMovies>>(
        future: fetchUpcomingMovies(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context , int){
                return GestureDetector(
                  onTap: (){
                    launchDetails(context, snapshot.data[int]);
//                Scaffold.of(context).showSnackBar(SnackBar(content: Text(snapshot.data[int].title)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: snapshot.data[int].title,
                        child: Card(
                          child: Image.network(IMAGE_BASE_URL + snapshot.data[int].posterPath ,
                            height: 150.0,
                            width: 150.0,
                            fit: BoxFit.fitWidth,),
                          elevation: 30.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        ),
                      ),
                      Center(child: Text(snapshot.data[int].title , style: TextStyle(color: Colors.white,),maxLines: 2,),),
                    ],
                  ),
                );

              },itemCount: snapshot.data.length,
            );
          }else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  void launchDetails(BuildContext context , UpcomingMovies name){
    Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context){
        return DetailsAnimator(name);
      },
    ));
  }
 }*/
