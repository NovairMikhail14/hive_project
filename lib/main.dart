import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_project/01-Data/User.dart';
import 'package:path_provider/path_provider.dart';
import '00-Screen/HomePage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path + "/HiveDB");
  await Hive.openBox<Map<dynamic,dynamic>>("HiveDB");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
        primarySwatch: Colors.deepPurple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor:  Colors.black),
        iconButtonTheme: IconButtonThemeData(style: ButtonStyle(overlayColor:MaterialStateProperty.all( Colors.black))),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black))
      ),
      debugShowCheckedModeBanner: false,
      // home:HomePage() ,
      initialRoute:"HomePage" ,
      routes: {
        "HomePage" :(context)=> HomePage()
      },
    );
  }
}
