import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/modules/API.dart';
import 'package:phonebook/screens/View.dart';
import 'package:phonebook/structures/PBPartialData.dart';
import 'package:phonebook/utils/Functions.dart';
import 'package:phonebook/utils/Toasts.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  int pnumTextFieldId = 0;

  TextEditingController fnameCtrlr = TextEditingController();
  TextEditingController lnameCtrlr = TextEditingController();
  List<PNumTextField> pnumTextFields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('New Contact'),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              List<String> conditions = [];

              // safe format input
              final fname = Functions.safeFormat(fnameCtrlr.text);
              final lname = Functions.safeFormat(lnameCtrlr.text);
              final pnums = pnumTextFields
                  .map((pnumfields) =>
                      Functions.safeFormat(pnumfields.controller.text))
                  .toList();

              // Check if all fields are valid
              if (fname.isEmpty) {
                conditions.add('First Name must not be empty.');
              }
              if (lname.isEmpty) {
                conditions.add('Last Name must not be empty.');
              }
              if (pnums.where((pnum) => pnum.isEmpty).length > 0) {
                conditions.add('Phone Numbers must not be empty.');
              }

              if (conditions.isNotEmpty) {
                Toasts.showMessage(conditions.join('\n'));
              } else {
                try {
                  final newData =
                      PBPartialData(first_name: fname, last_name: lname);
                  if (pnums.length > 0) newData.phone_numbers = pnums;
                  final thisContact = await API.putContact(newData);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => View(
                        id: thisContact.id,
                      ),
                    ),
                  );
                } catch (error) {
                  Toasts.showMessage(error.toString());
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person_add,
                color: Colors.white,
                size: 80,
              ),
              radius: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
              child: Column(
                children: [
                  TextField(
                    controller: fnameCtrlr,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'First Name',
                      labelText: 'First Name',
                    ),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                  TextField(
                    controller: lnameCtrlr,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Last Name',
                      labelText: 'Last Name',
                    ),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: 20),
                  ...pnumTextFields,
                  SizedBox(height: 20),
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text('Add Phone Number'),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        pnumTextFields.add(PNumTextField(
                          id: pnumTextFieldId++,
                          remove: (id) {
                            setState(() {
                              pnumTextFields.removeWhere((e) => e.id == id);
                            });
                          },
                        ));
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PNumTextField extends StatelessWidget {
  final id, remove, initial;
  final controller = TextEditingController();

  PNumTextField({
    Key? key,
    required int this.id,
    required this.remove,
    this.initial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initial != null) {
      controller.text = initial;
    }
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.call),
        hintText: 'Phone Number',
        labelText: 'Phone Number',
        suffixIcon: IconButton(
          icon: Icon(Icons.remove, color: Colors.red),
          onPressed: () {
            this.remove(id);
          },
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
