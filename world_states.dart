import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:covid_19_app/models/WorldStatesModel.dart';
import 'package:covid_19_app/services/states_services.dart';
import 'package:covid_19_app/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen> with TickerProviderStateMixin {  // Help to build animation

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
      vsync: this)..repeat();

  @override

  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  final colorlist = <Color> [
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context , snapshot1){
          return Scaffold(
            body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      FutureBuilder(
                          future: statesServices.fetchWorld(),
                          builder: (context ,AsyncSnapshot<WorldStatesModel> snapshot){
                            if(!snapshot.hasData){
                              return snapshot1.data == ConnectivityResult.none ?
                                  Text('No Internet' , style: TextStyle(
                                    color: Colors.white
                                  ),) :
                                  Expanded(
                                    child: SpinKitCircle(
                                      controller: _controller,
                                      size: 60,
                                      color: Colors.blueGrey,
                                    ),
                                  );
                            }
                            else{
                              return Column(
                                children: [
                                  PieChart(
                                      dataMap: {
                                        "Total" : double.parse(snapshot.data!.cases!.toString()),
                                        "Recovered" : double.parse(snapshot.data!.recovered!.toString()),
                                        "Deaths" : double.parse(snapshot.data!.deaths!.toString()),
                                      },
                                      chartValuesOptions: const ChartValuesOptions(
                                          showChartValuesInPercentage: true
                                      ),
                                      chartRadius: MediaQuery.of(context).size.width / 3,
                                      legendOptions: const LegendOptions(
                                          legendPosition: LegendPosition.right
                                      ),
                                      animationDuration: Duration(milliseconds: 1200),
                                      chartType: ChartType.ring,
                                      colorList: colorlist
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: MediaQuery.of(context).size.height * .000001
                                    ),
                                    child: Card(
                                      child: Column(
                                        children: [
                                          ReuseableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                                          ReuseableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                          ReuseableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                          ReuseableRow(title: 'Active', value: snapshot.data!.active.toString()),
                                          ReuseableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                                          ReuseableRow(title: 'Today Death', value: snapshot.data!.todayDeaths.toString()),
                                          ReuseableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap : (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CountriesList()));
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Color(0xff1aa260),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(
                                          child: Text('Track Countries')),
                                    ),
                                  )
                                ],
                              );
                            }
                          }
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    );
  }
}
class ReuseableRow extends StatelessWidget {
  final String title, value;

  ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 5
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value)
            ],
          ),
          // SizedBox(
          //   height: 1,
          // ),
          Divider()
        ],
      ),
    );
  }
}