import 'package:amazon_clone/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as chart;


class CategoryProductsChart extends StatelessWidget {
  final List<chart.LineSeries<SalesModel, String>> seriesList;
  const CategoryProductsChart({Key? key, required this.seriesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return chart.SfCartesianChart(
      series:seriesList,
      

    );
  }
}
