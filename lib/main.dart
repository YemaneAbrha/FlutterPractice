import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:networkPractice/interceptor/retry_interceptor.dart';
import 'package:networkPractice/interceptor/dio_connectivity_retryrier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio dio;
  String firstPostTitle;
  bool isLoading;
  @override
  void initState() {
    super.initState();
    dio = Dio();
    firstPostTitle = 'Press the button to load ';
    isLoading = false;

    dio.interceptors.add(RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
      dio: dio,
      connectivity: Connectivity(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isLoading)
              CircularProgressIndicator()
            else
              Text(
                firstPostTitle,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            RaisedButton(
                child: Text("RequestData Here"),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final respose = await dio
                      .get('https://jsonplaceholder.typicode.com/posts');
                  setState(() {
                    firstPostTitle = respose.data[0]['title'] as String;
                    isLoading = false;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
