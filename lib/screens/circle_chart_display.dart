import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/expenses.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './bar_chart_display.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CircleChartDisplay extends StatefulWidget {
  @override
  _CircleChartDisplayState createState() {
    return _CircleChartDisplayState();
  }
}

class _CircleChartDisplayState extends State<CircleChartDisplay> {
  List<charts.Series<Expenses, String>> _seriesPieData;
  List<Expenses> mydata;
  _generateData(mydata) {
    _seriesPieData = List<charts.Series<Expenses, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (Expenses expenses, _) => expenses.title,
        measureFn: (Expenses expenses, _) => expenses.value,
        colorFn: (Expenses expenses, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(expenses.color))),
        id: 'expenses',
        data: mydata,
        labelAccessorFn: (Expenses row, _) => "${row.display}",
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
              icon: Icon(FontAwesomeIcons.chartBar),
              onPressed: () {
                print('Chart Bar Graph');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarChartDisplay()),
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
                'Pie Chart',
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
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 2),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 1
                            : 3,
                        cellPadding: new EdgeInsets.all(4),
                        entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside,
                          )
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
