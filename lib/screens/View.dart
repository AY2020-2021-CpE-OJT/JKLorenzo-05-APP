import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/modules/API.dart';
import 'package:phonebook/screens/Manage.dart';
import 'package:phonebook/structures/PBData.dart';

class View extends StatelessWidget {
  final String id;
  const View({Key? key, required String this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API.getContact(id),
      builder: (context, AsyncSnapshot<PBData> snapshot) {
        return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.grey[850],
            title: Text('Contact'),
            centerTitle: true,
            actions: snapshot.hasData
                ? [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Manage(data: snapshot.data!),
                          ),
                        );
                      },
                    )
                  ]
                : null,
          ),
          body: Center(
            child: snapshot.hasData
                ? ListView(
                    children: [
                      SizedBox(height: 50),
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 80,
                        ),
                        radius: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: Colors.grey[450],
                            ),
                            SizedBox(height: 30),
                            Text(
                              'FIRST NAME',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              snapshot.data!.first_name,
                              style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'LAST NAME',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              snapshot.data!.last_name,
                              style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...renderPNums(snapshot.data!.phone_numbers),
                          ],
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  List<Widget> renderPNums(List<String> phone_numbers) {
    final List<Widget> widgets = [];
    if (phone_numbers.length > 0) {
      widgets.addAll([
        SizedBox(height: 30),
        Text(
          'PHONE NUMBERS',
          style: TextStyle(
            color: Colors.grey,
            letterSpacing: 2,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
      ]);

      for (int index = 0; index < phone_numbers.length; index++) {
        widgets.addAll([
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.call),
                  SizedBox(width: 5),
                  Text(
                    phone_numbers[index],
                    style: TextStyle(
                      color: Colors.grey[400],
                      letterSpacing: 2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
            ],
          )
        ]);
      }
    }
    return widgets;
  }
}
