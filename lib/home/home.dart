// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Reminders")),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/reminders'),
                  child: Wrap(
                    children: [
                      Card(
                          color: Colors.red.shade400,
                          elevation: 2,
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text("Recordatorios",
                                style: Theme.of(context).textTheme.headline1),
                          )))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/records'),
                    child: Wrap(
                      children: [
                        Card(
                            color: Colors.blue.shade400,
                            elevation: 2,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text("Registros",
                                  style: Theme.of(context).textTheme.headline1),
                            )))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void onFormSubmit() {}
}
