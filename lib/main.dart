import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './screens/bar_chart_display.dart';
import './screens/circle_chart_display.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Chart',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly Expenses',
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.chartBar),
              onPressed: () {
                print('Chart Bar Graph');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarChartDisplay()),
                );
              }),
          IconButton(
              icon: Icon(FontAwesomeIcons.chartPie),
              onPressed: () {
                print('Chart Pie Graph');
                print('Chart Bar Graph');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CircleChartDisplay()),
                );
              }),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('WeeklyExpenses').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemBuilder: (ctx, index) {
              DocumentSnapshot weeklyexpenses = snapshot.data.documents[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.all(6),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\u20B9${weeklyexpenses['value']}'),
                      ),
                    ),
                  ),
                  title: Text(
                    weeklyexpenses['title'],
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  subtitle: Text(
                    weeklyexpenses['subtitle'],
                    style: TextStyle(fontFamily: 'Quicksand'),
                  ),
                ),
              );
            },
            itemCount: snapshot.data.documents.length,
          );
        },
      ),
    );
  }
}
