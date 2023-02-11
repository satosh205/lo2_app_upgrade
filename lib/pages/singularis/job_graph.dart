// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:masterg/blocs/home_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:masterg/utils/resource/colors.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class JobGrowth extends StatefulWidget {
//   const JobGrowth({Key? key}) : super(key: key);

//   @override
//   State<JobGrowth> createState() => _JobGrowthState();
// }

// class _JobGrowthState extends State<JobGrowth> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<HomeBloc, HomeState>(
//       listener: (context, state) {},
//       child: Scaffold(
//         backgroundColor: ColorConstants.WHITE,
//           body: Column(
//         children: [
//           Center(
//             child: Container(
//               child: Column(
//                 children: [Text('+6.6%'), Text('Projected Growth')],
//               ),
//             ),
//           ),
//           // Container(
//           //     child: SfCartesianChart(
//           //         // Initialize category axis
//           //         primaryXAxis: CategoryAxis(),
//           //         series: <LineSeries<SalesData, String>>[
//           //       LineSeries<SalesData, String>(
//           //           // Bind data source
//           //           dataSource: <SalesData>[
//           //             SalesData('Jan', 35),
//           //             SalesData('Feb', 28),
//           //             SalesData('Mar', 34),
//           //             SalesData('Apr', 32),
//           //             SalesData('May', 40)
//           //           ],
//           //           xValueMapper: (SalesData sales, _) => sales.year,
//           //           yValueMapper: (SalesData sales, _) => sales.sales)
//           //     ]))
//         ],
//       )),
//     );
//   }
// }

// class SalesData {
//   SalesData(this.year, this.sales);
//   final String year;
//   final double sales;
// }
