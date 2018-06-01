import 'package:flutter/material.dart';
import 'package:movies_flutter/data/upcomingmovies.dart';
import 'package:movies_flutter/ui/detailspage.dart';

class DetailsAnimator extends StatefulWidget {

  DetailsAnimator(this.mUpcomingMovies);
  final UpcomingMovies mUpcomingMovies;

  @override
  _DetailsAnimatorState createState() => new _DetailsAnimatorState(mUpcomingMovies);
}

class _DetailsAnimatorState extends State<DetailsAnimator> with
            SingleTickerProviderStateMixin{

  _DetailsAnimatorState(this.mUpcomingMovies);
  UpcomingMovies mUpcomingMovies;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
    duration: Duration(seconds: 2)
    ,vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new DetailsPage(mUpcomingMovies , _animationController);
  }
}
