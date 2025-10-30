import 'package:covid_19_app/services/states_services.dart';
import 'package:covid_19_app/view/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({super.key});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {

  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        scrolledUnderElevation: 0.0,  // disable the appbar color when scrolling
      ),
      body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                  left: 15
                ),
                child: TextFormField(
                  controller: searchcontroller,
                  onChanged: (value){
                    setState(() {
                      
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20
                    ),
                    hintText: "Search With Country Name",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60.0)
                    )
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                  child: FutureBuilder(
                      future: statesServices.fetchCountry(),
                      builder: (context ,AsyncSnapshot<List<dynamic>> snapshot){
                        if(!snapshot.hasData){
                          return ListView.builder(
                            itemCount: 8,
                              itemBuilder: (context , index){
                                return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade700,
                                    highlightColor: Colors.grey.shade100,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title : Container(height: 10, width: 89, color: Colors.white),
                                          subtitle : Container(height: 10, width: 89, color: Colors.white),
                                          leading: Container(height: 50, width: 50, color: Colors.white),
                                        )
                                      ],
                                    )
                                );
                              }
                          );
                        }
                        else{
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                              itemBuilder: (context , index){
                              String name = snapshot.data![index]['country'];

                              if(searchcontroller.text.isEmpty){
                                return InkWell(
                                  onTap : (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                                      name: snapshot.data![index]['country'],
                                      image: snapshot.data![index]['countryInfo']['flag'],
                                      totalCases: snapshot.data![index]['cases'],
                                      totalRecovered: snapshot.data![index]['recovered'],
                                      totalDeath: snapshot.data![index]['deaths'],
                                      active: snapshot.data![index]['active'],
                                      test: snapshot.data![index]['tests'],
                                      todayRecovered: snapshot.data![index]['todayRecovered'],
                                      critical: snapshot.data![index]['critical'],

                                    )));
                                  },
                                  child: ListTile(
                                    title : Text(snapshot.data![index]['country']),
                                    subtitle : Text(snapshot.data![index]['cases'].toString()) ,
                                    leading: Image(
                                        height : 55,
                                        width: 55,
                                        image: NetworkImage(snapshot.data![index]['countryInfo']['flag'])
                                    ),
                                  ),
                                );
                              }
                              else if(name.toLowerCase().contains(searchcontroller.text.toLowerCase())){
                                return InkWell(
                                  onTap : (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                                      name: snapshot.data![index]['country'],
                                      image: snapshot.data![index]['countryInfo']['flag'],
                                      totalCases: snapshot.data![index]['cases'],
                                      totalRecovered: snapshot.data![index]['recovered'],
                                      totalDeath: snapshot.data![index]['deaths'],
                                      active: snapshot.data![index]['active'],
                                      test: snapshot.data![index]['tests'],
                                      todayRecovered: snapshot.data![index]['todayRecovered'],
                                      critical: snapshot.data![index]['critical'],

                                    )));
                                  },
                                  child: ListTile(
                                    title : Text(snapshot.data![index]['country']),
                                    subtitle : Text(snapshot.data![index]['cases'].toString()) ,
                                    leading: Image(
                                        height : 55,
                                        width: 55,
                                        image: NetworkImage(snapshot.data![index]['countryInfo']['flag'])
                                    ),
                                  ),
                                );
                              }
                              else{
                                return Column(
                                  children: [

                                  ],
                                );
                              }
                            }
                          );
                        }
                      }
                  )
              )
            ],
          )
      ),
    );
  }
}
