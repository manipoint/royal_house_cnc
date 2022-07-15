import 'package:amazon_clone/pages/admin/widgets/cat_products_charts.dart';
import 'package:amazon_clone/util/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../../models/order_model.dart';
import '../services/admin_services.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<SalesModel>? earnings;

  @override
  void initState() {
    super.initState();
    getEarning();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return earnings == null || totalSales == null
        ? const Loader()
        : SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Rs $totalSales',
                  style: TextStyle(
                    fontSize: width / (width / 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height: width / 2,
                    child: SfCircularChart(
                     
                      legend: Legend(isVisible: true),
                      series: <PieSeries<SalesModel, String>>[
                        PieSeries<SalesModel, String>(
                          explode: true,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true,labelPosition: ChartDataLabelPosition.outside),
                          xValueMapper: (SalesModel model, _) => model.label,
                          dataLabelMapper: (SalesModel model, _) => model.label,
                          yValueMapper: (SalesModel model, _) => model.earning,
                          dataSource: earnings,
                          enableTooltip: true,

                        )
                      ],
                    )),
                SizedBox(
                  height: width / 2,
                  child: SfCartesianChart(
                    legend: Legend(isResponsive: true, isVisible: true),
                    series: <ChartSeries>[
                      BarSeries<SalesModel, String>(
                          dataSource: earnings!,
                          xValueMapper: (SalesModel model, _) => model.label,
                          yValueMapper: (SalesModel model, _) => model.earning / 210,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          enableTooltip: true),
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        numberFormat:
                            NumberFormat.simpleCurrency(decimalDigits: 0),
                        title: AxisTitle(text: "Sales in US Dollars")),
                  ),
                )
              ],
            ),
          );
  }
  // SizedBox(
  //               height: width/2,
  //               child: CategoryProductsChart(seriesList: [
  //                 chart.LineSeries(
  //                   xValueMapper: (SalesModel sales, _) => sales.label,
  //                   yValueMapper: (SalesModel sales, _) => sales.earning,
  //                   dataSource: earnings!,

  //                 )
  //               ]),
  //             )
  void getEarning() async {
    var earningData = await adminServices.getEarning(context: context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }
}
