import 'package:flutter/material.dart';
import 'package:stopwtch_app_hasan/pages/stopwatch.dart';
import 'package:stopwtch_app_hasan/pages/timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch Timer Original',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch Timer Original'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'STOPWATCH'),
            Tab(text: 'TIMER'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StopwatchPage(),
          TimerPage(),
        ],
      ),
    );
  }
}
