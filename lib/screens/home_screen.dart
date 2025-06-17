import 'dart:convert';
import 'package:climate_app/constant.dart';
import 'package:climate_app/screens/firstscreen.dart';
import 'package:climate_app/services/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    if (mounted) {
      getLocation();
    }
    super.initState();
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    double lat = location.latitude;
    double lon = location.longitude;
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather',
        {'lat': lat.toString(), 'lon': lon.toString(), 'appid': apiKey});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FirstScreen(weatherData: data,)));
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 12,strokeAlign: BorderSide.strokeAlignOutside,),
      ),
    );
  }
}
