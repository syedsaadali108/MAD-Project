import 'dart:convert';

import 'package:covid_19_app/services/utilities/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/WorldStatesModel.dart';

class StatesServices{

  Future<WorldStatesModel> fetchWorld() async{
    final responce = await http.get(Uri.parse(AppUrl.worldstatesurl));
    if(responce.statusCode == 200){
      var data = jsonDecode(responce.body);
      return WorldStatesModel.fromJson(data);
    }
    else{
      throw Exception('Error');
    }
  }
  Future<List<dynamic>> fetchCountry() async{
    var data;
    final responce = await http.get(Uri.parse(AppUrl.countrystatesurl));
    if(responce.statusCode == 200){
      data = jsonDecode(responce.body);
      return data;
    }
    else{
      throw Exception('Error');
    }
  }
}