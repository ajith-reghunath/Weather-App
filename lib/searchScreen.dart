import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:weather_app/Design/itemtile.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoaded = false;
  num? temp=0;
  num? pressure;
  num? humidity;
  String cityName = '';
  TextEditingController controller = TextEditingController();

  getCityWeather(String cityName) async {
    var client = Client();
    var uri = '${domain}q=$cityName&appid=$apiKey';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
      print(data);
    } else {
      print(response.statusCode);
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              width: size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  setState(() {
                    cityName = value;
                    getCityWeather(value);
                    isLoaded = false;
                    // controller.clear();
                  });
                },
                controller: controller,
                cursorColor: Colors.white,
                style: const TextStyle(
                    color: Color.fromARGB(255, 231, 231, 231),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                    hintText: 'Search City',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 190, 190, 190),
                        fontWeight: FontWeight.normal),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                    border: InputBorder.none),
              ),
            ),
            Visibility(
            visible: isLoaded,
            replacement: Container(
              height: 100,
              child: const Center(
                child: Text('No data available',style: TextStyle(fontSize: 20, color: Colors.black),),
              ),
            ),
            child: Column(
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
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    controller;
    super.dispose();
  }
}
