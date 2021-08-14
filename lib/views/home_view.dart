import 'package:ajocard_sales_kit/views/chat_view.dart';
import 'package:ajocard_sales_kit/views/task_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'calculator_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_tabChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _tabChanged() {
    // Check if Tab Controller index is changing, otherwise we get the notice twice
    if (_tabController.indexIsChanging) {
      print('tabChanged: ${_tabController.index}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajocard Sales Kit"),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            CalculatorForm(),
            TaskPage(),
            ChatPage(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.black12,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(
                icon: Icon(Icons.calculate),
                text: 'Cost Calculator',
              ),
              Tab(
                icon: Icon(Icons.task),
                text: 'My Todo!',
              ),
              Tab(
                icon: Icon(Icons.message),
                text: 'Chat Customer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
