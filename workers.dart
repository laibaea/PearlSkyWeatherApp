import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:project_weather_app/home.dart';

class worker {
  late String location;
  worker({required this.location}) {
    location = this.location;
  }
  late String temp;
  late String humidity;
  late String airSpeed;
  late String desc;
  late String main;
  late String icon;

  getData() async {
    try {
      Response response = await get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=${location}&appid=5a91d846daeaa8d269ce315e0919924e'));
      Map data = jsonDecode(response.body);
      List weather_data = data['weather'];
      Map weather_main_data = weather_data[0];
      print(weather_data);
      print(weather_main_data);
      Map temp_data = data['main'];
      double getTemp = temp_data['temp'] - 272.15;
      Map humid_data = data['main'];
      int getHumidity = humid_data['humidity'];
      Map wind_data = data['wind'];
      double getAirSpeed = wind_data['speed'] * 3.6;
      String getDesc = weather_main_data['description'];
      String getMainDesc = weather_main_data['main'];
      String getIcon = weather_main_data["icon"];

      temp = getTemp.toStringAsFixed(0);
      humidity = getHumidity.toString();
      airSpeed = getAirSpeed.toStringAsFixed(2);
      desc = getDesc.toString();
      main = getMainDesc.toString();
      icon = getIcon.toString();
    } catch (e) {
      temp = "N/A";
      humidity = "N/A";
      airSpeed = "N/A";
      desc = "N/A";
      icon = "01d";
    }
  }
}

class loading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => loadingState();
}

class loadingState extends State<loading> {
  late String temp;
  late String humidity;
  late String airSpeed;
  late String desc;
  String loc = "Wah Cantt";
  late String icon;

  void startApp(String loc) async {
    worker obj = worker(location: loc);
    await obj.getData();
    // temp=obj.temp;
    // humidity=obj.humidity;
    // airSpeed=obj.airSpeed;
    // desc=obj.desc;
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => homeScreen(),
            settings: RouteSettings(
              arguments: {
                'temp_value': obj.temp,
                'humid_value': obj.humidity,
                'speed_value': obj.airSpeed,
                'desc_value': obj.desc,
                'loc_value': loc,
                'icon_value': obj.icon,
              },
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Map? search = ModalRoute.of(context)?.settings.arguments as Map?;
    if (search?.isNotEmpty ?? false) {
      loc = search?['searchText'];
    }
    startApp(loc);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 223, 229), // Pastel Pink
                  Color.fromARGB(255, 255, 182, 193), // Light Pink
                  Color.fromARGB(255, 255, 160, 200), // Soft Blush Pink
                  Color.fromARGB(
                      255, 255, 245, 247), // Very Light Pink (Pink Mist)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.cloud, size: 100, color: Colors.white),
                  Image.asset('assets/images/weather.png',
                      height: 200, width: 200),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'PearlSky',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SpinKitFoldingCube(
                    color: Colors.white,
                    size: 40.0,
                  ),
                ],
              ),
            )));
  }
}
