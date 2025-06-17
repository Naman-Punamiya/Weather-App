import 'dart:convert';
import 'package:climate_app/constant.dart';
import 'package:climate_app/screens/secondscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirstScreen extends StatefulWidget {
  final weatherData;
  const FirstScreen({super.key, required this.weatherData});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  var cityName;
  var currentWeather;
  var tempInCel;
  var emoji = '';

  var windspeed = "";
  var humidity = "";
  var feels_like = "";

  @override
  void initState() {
    // TODO: implement initState
    updateUI(widget.weatherData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Text(
          cityName,
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              updateUI(widget.weatherData);
            },
            icon: Icon(
              Icons.near_me,
              color: Colors.white,
              size: 30,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                var enteredCityName = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Secondscreen()),
                );
                if (enteredCityName != null && enteredCityName != "") {
                  var newWeatherData = await getWeatherDataFromCityName(
                      enteredCityName.toString());
                  if (newWeatherData.isNotEmpty) {
                    updateUI(newWeatherData);
                  }
                }
              },
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      backgroundColor: Colors.black38,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 200,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "$tempInCel°C",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              currentWeather,
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white24,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "💨",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "$windspeed km/h",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Wind",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Container(
                        width: 0.25,
                        height: 50,
                        color: Colors.white54,
                      ),
                      Column(
                        children: [
                          Text(
                            "💧",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "$humidity%",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Humidity",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Container(
                        width: 0.25,
                        height: 50,
                        color: Colors.white54,
                      ),
                      Column(
                        children: [
                          Text(
                            "⛅",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "$feels_like°C",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Feels Like",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  String kelvinToCel(var temp) {
    var tempInCel = temp - 273.15;
    String tempInString = tempInCel.floor().toString();
    return tempInString;
  }

  Future<Map<String, dynamic>> getWeatherDataFromCityName(
      String cityName) async {
    try {
      var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'q': cityName,
        'appid': apiKey,
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var weatherData = jsonDecode(response.body);
        return weatherData;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('City not found or API error'),
          backgroundColor: Colors.red,
        ));
        return {};
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong. Please check your connection.'),
        backgroundColor: Colors.red,
      ));
      return {};
    }
  }

  void updateUI(weatherData) {
    var weatherid = weatherData['weather'][0]['id'];
    if (weatherid >= 200 && weatherid < 300) {
      setState(() {
        emoji = "🌩";
      });
    } else if (weatherid >= 300 && weatherid < 400) {
      setState(() {
        emoji = "⛈";
      });
    } else if (weatherid >= 500 && weatherid < 600) {
      setState(() {
        emoji = "🌧";
      });
    } else if (weatherid >= 600 && weatherid < 700) {
      setState(() {
        emoji = "🌨";
      });
    } else if (weatherid >= 700 && weatherid < 800) {
      setState(() {
        emoji = "❄";
      });
    } else if (weatherid == 800) {
      setState(() {
        emoji = "☀";
      });
    } else if (weatherid > 800 && weatherid < 900) {
      setState(() {
        emoji = "☁";
      });
    } else {
      setState(() {
        emoji = "❔";
      });
    }

    setState(() {
      var temp = weatherData['main']['temp'];
      tempInCel = kelvinToCel(temp);
      currentWeather = weatherData['weather'][0]['main'];
      cityName = weatherData['name'];
      feels_like = kelvinToCel(weatherData['main']['feels_like']);
      humidity = weatherData['main']['humidity'].toString();
      windspeed = weatherData['wind']['speed'].toString();
    });
  }
}
