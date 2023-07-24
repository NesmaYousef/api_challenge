import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<dynamic> getData() async {
    Response response = await get(
      Uri.parse('https://catfact.ninja/fact?max_length=140'),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> getImage() async {
    Response responseImage =
        await get(Uri.parse('https://api.thecatapi.com/v1/images/search'));

    if (responseImage.statusCode == 200) {
      print(responseImage.body);
      return jsonDecode(responseImage.body);
    }
  }

  @override
  void initState() {
    getData();
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: FutureBuilder<dynamic>(
                    future: getImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 150,
                            backgroundImage: AssetImage(
                                'images/wait.gif')); // Show a loading indicator while waiting for data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.hasData) {
                          final imageData = snapshot.data;
                          final image = imageData[0][
                              'url']; // Assuming the API response contains image
                          return CircleAvatar(
                            backgroundImage: NetworkImage(image),
                            radius: 100,
                          );
                        } else {
                          return Text('No image available');
                        }
                      }
                    },
                  ),
                ),
                FutureBuilder<dynamic>(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Another Cat Fact:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.gamjaFlower(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ); // Show a loading indicator while waiting for data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          final fact = data[
                              'fact']; // Assuming the API response contains a 'fact' field
                          return AutoSizeText(
                            fact,
                            style: GoogleFonts.gamjaFlower(
                                fontWeight: FontWeight.bold, fontSize: 28),
                            maxLines: 3,
                          );
                        } else {
                          return Text('No fact available');
                        }
                      }
                    }),
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Image(
                        image: AssetImage('images/catgif.gif'),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xffd4bdef))),
                                child: Text(
                                  'Meow',
                                  style: GoogleFonts.gamjaFlower(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ))),
                      ],
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
