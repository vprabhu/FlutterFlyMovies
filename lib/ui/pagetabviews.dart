import 'package:flutter/material.dart';

class CustomTabViews extends StatefulWidget {

  @override
  _MoviesPageViewState createState() => new _MoviesPageViewState();
}

class _MoviesPageViewState extends State<CustomTabViews>  with
    SingleTickerProviderStateMixin{

  String _indicatorString = "Upcoming";

  double containerOneOpacity = 1.0;
  double containerTwoOpacity = 0.4;
  double containerThreeOpacity = 0.4;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
//    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Swiped"),  ));
    setState(() {
      changeIndicator(_tabController.index);
    });
  }

  void changeIndicator(int indicatorIndex){
    switch(indicatorIndex){
      case 0 :{
        _indicatorString = "UpComing";
        containerOneOpacity =1.0;
        containerTwoOpacity =0.4;
        containerThreeOpacity =0.4;
      }break;
      case 1 :{
        _indicatorString = "In theatres";
        containerOneOpacity =0.4;
        containerTwoOpacity =1.0;
        containerThreeOpacity =0.4;
      }break;
      case 2 :{
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: new Scaffold(
          body: NestedScrollView(
            scrollDirection: Axis.vertical,
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
              children: [
                Container(
                    height: 250.0,
                    width: 250.0,
                    child: Text("One" , style: TextStyle(color: Colors.black,fontSize: 25.0),)),
                Container(
                    height: 250.0,
                    width: 250.0,
                    child: Text("Two" , style: TextStyle(color: Colors.black,fontSize: 25.0),)),
                Container(
                    height: 250.0,
                    width: 250.0,
                    child: Text("Three" , style: TextStyle(color: Colors.black,fontSize: 25.0),)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _returnColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 32.0,),
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
}