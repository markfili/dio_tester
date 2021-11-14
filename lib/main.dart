import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dio tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _forceError();
  }

  var httpClient = Dio(
    BaseOptions(
      baseUrl: "https://gorest.co.in/public/v1",
      contentType: "application/json",
    ),
  );

  var message = "^push to start ^";

  Future<void> _forceError() async {
    try {
      var response = await httpClient.get("/posts/nonExistingId");
    } on DioError catch (dioError) {
      display("DioError catch: ${dioError.message}");
    } catch (e) {
      display("Other exception catch: ${e.toString()}");
    }
  }

  Future<void> _forceErrorWithCatchError() async {
    try {
      var response = await httpClient.get("/posts/nonExistingId").catchError((e) {
        display("Error in catchError:\n$e");
        return Response(requestOptions: RequestOptions(path: "not really sure how to return Future's type"));
      });
    } on DioError catch (dioError) {
      display("DioError catch: ${dioError.message}");
    } catch (e) {
      display("Other exception catch: ${e.toString()}");
    }
  }

  void display(String message) {
    setState(() {
      this.message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hello, Ahmed!"),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: () async => await _forceError(),
                    child: const Text("Test try/catching!"),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: () async => await _forceErrorWithCatchError(),
                    child: const Text("Test catchError!"),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(message),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
