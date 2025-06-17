import 'package:flutter/material.dart';

class Secondscreen extends StatefulWidget {
  const Secondscreen({super.key});

  @override
  State<Secondscreen> createState() => _SecondscreenState();
}

class _SecondscreenState extends State<Secondscreen> {
  TextEditingController cityNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
              child: TextFormField(
                controller: cityNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    hintText: "Write a City Name...",
                    fillColor: Colors.white12,
                    filled: true
                    ),
              ),
            ),
            SizedBox(height: 25,),
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context, cityNameController.text.trimRight());
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        "Get Weather",
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
