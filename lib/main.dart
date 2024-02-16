import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars Characters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Star Wars Characters',
        // name: 'Darth Vader',
        age: 45,
        // eyeColor: 'green',
        // hairColor: 'brown',
        imageUrl: 'https://starwars-visualguide.com/assets/img/characters/4.jpg',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
    // required this.name,
    required this.age,
    // required this.eyeColor,
    // required this.hairColor,
    required this.imageUrl,
  }) : super(key: key);

  final String title;
  // final String name;
  final int age;
  // final String eyeColor;
  // final String hairColor;
  final String imageUrl;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> _futureCharacter;

  @override
  void initState() {
    super.initState();
    _futureCharacter = _fetchCharacter();
  }

  Future<Map<String, dynamic>> _fetchCharacter() async {
    final response = await http.get(
      Uri.parse('https://swapi.dev/api/people/4/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load character');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(widget.imageUrl),
            // Text('Nombre: ${widget.name}'),
           
            // Text('Color de ojos: ${widget.eyeColor}'),
            // Text('Color de pelo: ${widget.hairColor}'),
            FutureBuilder<Map<String, dynamic>>(
              future: _futureCharacter,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Nombre: ${snapshot.data!['name']}'),
                      Text('Edad: ${widget.age}'),
                      Text('Altura: ${snapshot.data!['height']}'),
                      Text('Masa: ${snapshot.data!['mass']}'),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}