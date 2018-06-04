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

  /// string to indicate the tab selection which is
  /// upcoming, in theatres, top rated and the default is set to upcoming
  String _tabindicatorString = "Upcoming";

  /// tabs opacity which here we use it to change the tab indication
  double tabOneOpacity = 1.0;
  double tabTwoOpacity = 0.4;
  double tabThreeOpacity = 0.4;

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
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverList(
                    delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return _returnTabControllerUI();
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

  /// handles the tab selection i.e,
  /// 1.Changing the tab selection
  /// 2.fetch the movies list against the tab selection
  void _handleTabSelection() {
    this.setState(() {
      changeIndicator(_tabController.index);
    });
  }

  /// method to change the indicator tab color and fetches the movies list from
  /// json according to the category selected
  /// @indicatorIndex - current Tab index
  void changeIndicator(int indicatorIndex){
    switch(indicatorIndex){
      case 0 :
        _tabindicatorString = UPCOMING_TAB_TITLE;
        tabOneOpacity =1.0;
        tabTwoOpacity =0.4;
        tabThreeOpacity =0.4;
        break;
      case 1 :{
        this.fetchNowPlayingMovies();
        _tabindicatorString = NOW_PLAYING_TAB_TITLE;
        tabOneOpacity =0.4;
        tabTwoOpacity =1.0;
        tabThreeOpacity =0.4;
      }break;
      case 2 :{
        this.fetchTopRatedMovies();
        _tabindicatorString = TOP_RATED_TAB_TITLE;
        tabOneOpacity =0.4;
        tabTwoOpacity =0.4;
        tabThreeOpacity =1.0;
      }break;

    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// fetches the Upcoming movies
  Future<List<UpcomingMovies>> fetchUpcomingMovies() async{
    final response = await http.get(BASE_URL + UPCOMING_MOVIES +"?api_key="+API_KEY+"&page=1");
    var responseJson = json.decode(response.body.toString());
    this.setState((){
      upcomingMoviesList = parseUpcomingMoviesJson(responseJson["results"]);
    });
    return upcomingMoviesList;
  }

  /// fetches the Now Playing Movies
  Future<List<UpcomingMovies>> fetchNowPlayingMovies() async{
    final response = await http.get(BASE_URL + NOW_PLAYING +"?api_key="+API_KEY+"&language=en-US&page=1");
    var responseJson = json.decode(response.body.toString());
    this.setState((){
      nowPlayingList = parseUpcomingMoviesJson(responseJson["results"]);
    });
    return nowPlayingList;
  }

  /// fetches the Top rated movies
  Future<List<UpcomingMovies>> fetchTopRatedMovies() async{
    final response = await http.get(BASE_URL + TOP_RATED +"?api_key="+API_KEY+"&language=en-US&page=1");
    var responseJson = json.decode(response.body.toString());
    this.setState((){
      topRatedList = parseUpcomingMoviesJson(responseJson["results"]);
    });
    return topRatedList;
  }

  /// parses the json in to movies list
  /// @moviesJson - raw json containing the movie's info
  List<UpcomingMovies> parseUpcomingMoviesJson(var moviesJson){
    List<UpcomingMovies> moviesTempList = new List();
    for(int i = 0 ; i< moviesJson.length ; i++ ){
      String image = moviesJson[i]["poster_path"];
      String title = moviesJson[i]["title"];
      String overview = moviesJson[i]["overview"];
      String voteAverage = moviesJson[i]["vote_average"].toString();
      var upcomingMovies = new UpcomingMovies(image , title , overview , voteAverage);
      moviesTempList.add(upcomingMovies);
    }
    return moviesTempList;
  }

  /// builds the gridview and its childs
  /// @moviesList list of movies to be filled in gridview
  Widget _buildGridView(List<UpcomingMovies> moviesList){
    return Center(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context , int){
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

  /// this method returns the tab controller as a whole which is
  /// text and indicator tabs as a whole widget
  Widget _returnTabControllerUI(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 38.0,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(_tabindicatorString ,
            style: TextStyle(fontWeight: FontWeight.bold ,
                fontSize: 18.0
                ,color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width : 5.0,),
            _returnTabUI(tabOneOpacity),
            SizedBox(width: 5.0,),
            _returnTabUI(tabTwoOpacity),
            SizedBox(width: 5.0,),
            _returnTabUI(tabThreeOpacity),
          ],
        ),
      ],
    );
  }

  /// this method constructs the rectangle which is used as tab's
  /// small indicator
  /// @opacityValue - to control the tab indicator color
  Widget _returnTabUI(double opacityValue){
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      color: Colors.white.withOpacity(opacityValue),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      width: 30.0,
      height: 2.5,
    );
  }

  /// this method launches the details page through the DetailsAnimator
  /// which basically animated the content of the details page
  void launchDetails(BuildContext context , UpcomingMovies name){
    Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context){
        return DetailsAnimator(name);
      },
    ));
  }
}