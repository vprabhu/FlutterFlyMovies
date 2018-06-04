import 'package:flutter/material.dart';
import 'package:movies_flutter/data/upcomingmovies.dart';
import 'package:movies_flutter/utils/constants.dart';
import 'dart:core';
import 'package:movies_flutter/anim/details_enter_animation.dart';

class DetailsPage extends StatefulWidget{

  DetailsPage(
      this.mUpcomingMovies , this.animationController);
  final UpcomingMovies mUpcomingMovies;
  final AnimationController animationController;

  @override
  _DetailsPageState createState() => _DetailsPageState(mUpcomingMovies , animationController);

}

class _DetailsPageState extends State<DetailsPage>{

  _DetailsPageState(this.mUpcomingMovies , this.animationController)
      : animation = new DetailsEnterAnimation(animationController);
  UpcomingMovies mUpcomingMovies;
  AnimationController animationController;
  DetailsEnterAnimation animation ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
      ),

      body:  AnimatedBuilder(
          animation: animation.controller,
          builder: _buildAnimation),
    );
  }

  Widget _buildAnimation(BuildContext context , Widget child){
    return Container(
      child: _buildDetailsPage(),
    );
  }

  Widget _buildDetailsPage(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30.0,),
            Hero(
              tag: mUpcomingMovies.title,
              child: Card(
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: Image.network(IMAGE_BASE_URL+mUpcomingMovies.posterPath , height: 250.0 , width: 300.0 , fit: BoxFit.fitWidth,)),
            ) ,
            SizedBox(height: 15.0,),
            Transform(
              transform: Matrix4.diagonal3Values(
                  animation.nameCurveAnimation.value,
                  animation.nameCurveAnimation.value,
                  1.0),
              child: Text(
                mUpcomingMovies.title ,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(animation.nameCurveAnimation.value) ,
                    fontSize: 30.0 ,
                    fontFamily: 'RobotoCondensed',
                    fontStyle: FontStyle.normal),
              ),
            ),
            SizedBox(height: 15.0,),
            Transform(
              transform: Matrix4.diagonal3Values(
                  animation.nameCurveAnimation.value,
                  animation.nameCurveAnimation.value,
                  1.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(mUpcomingMovies.overview , style: TextStyle(fontSize: 18.0 ,color: Colors.white),),
              ),
            ) ,
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 70.0,
                    width: 70.0,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white.withOpacity(animation.nameCurveAnimation.value) ,
                          width: 2.5),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child:new Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        mUpcomingMovies.voteAverage ,
                        style: TextStyle(
                          color: Colors.white.withOpacity(animation.nameCurveAnimation.value),
                          fontSize: 15.0,),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }

}