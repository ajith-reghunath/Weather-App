import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weather_app/Design/itemtile.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/design.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;
  num? temp=0;
  num? pressure;
  num? humidity;
  String cityName = '';

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    var location = await Geolocator.getCurrentPosition();
    print(
        'latitude : ${location.latitude}   longitude : ${location.longitude}');
    getCurrentLocationWeather(location);
  }

  getCurrentLocationWeather(Position position) async {
    var client = Client();
    var uri =
        '${domain}lat=${position.latitude}&lon=${position.longitude}&exclude={part}&appid=$apiKey';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
      // print(data);
    } else {
      // print(response.statusCode);
    }
  }

  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        pressure = 0;
        humidity = 0;
        cityName = 'Not Available';
      } else {
        temp = decodedData['main']['temp'] - 273;
        pressure = decodedData['main']['pressure'];
        humidity = decodedData['main']['humidity'];
        cityName = decodedData['name'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Weathery',
          style: TextStyle(fontSize: appBarFontSize),
        )),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 60,
                      ),
                      Text(
                        cityName,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                ItemTile(
                    icon: Icons.thermostat,
                    text: 'Temparature : ${temp!.round()} °C'),
                kHeight,
                ItemTile(
                    icon: Icons.settings_input_svideo,
                    text: 'Pressure : $pressure hPa'),
                kHeight,
                ItemTile(icon: Icons.water_drop, text: 'Humidity : $humidity %')
              ],
            ),
          ),
        ),
      ),
    );
  }
}


