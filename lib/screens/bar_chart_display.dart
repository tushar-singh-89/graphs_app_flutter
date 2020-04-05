import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/expenses.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './circle_chart_display.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class BarChartDisplay extends StatefulWidget {
  @override
  _BarChartDisplayState createState() {
    return _BarChartDisplayState();
  }
}

class _BarChartDisplayState extends State<BarChartDisplay> {
  List<charts.Series<Expenses, String>> _seriesBarData;
  List<Expenses> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<Expenses, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (Expenses expenses, _) => expenses.display,
        measureFn: (Expenses expenses, _) => expenses.value,
        colorFn: (Expenses expenses, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(expenses.color))),
        id: 'Expenses',
        data: mydata,
        labelAccessorFn: (Expenses expenses, _) => '${expenses.title}',
      ),
    );
  }

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
              icon: Icon(FontAwesomeIcons.chartPie),
              onPressed: () {
                print('Chart Circle Graph');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CircleChartDisplay()),
                );
              }),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('WeeklyExpenses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Expenses> expenses = snapshot.data.documents
              .map(
                  (documentSnapshot) => Expenses.fromMap(documentSnapshot.data))
              .toList();
          return _buildChart(context, expenses);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Expenses> expensedata) {
    mydata = expensedata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Bar Chart',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                  behaviors: [
                    new charts.DatumLegend(
                      desiredMaxRows: 2,
                      entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
