import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/modules/API.dart';
import 'package:phonebook/screens/Create.dart';
import 'package:phonebook/screens/View.dart';
import 'package:phonebook/structures/PBPartialData.dart';
import 'package:phonebook/utils/Toasts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<PBPartialData>> _future = API.getContacts();
  bool _isLoading = true;
  bool _isEditting = false;
  List<PBPartialData> _contacts = [];
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    periodicUpdate();
  }

  periodicUpdate() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        _future = API.getContacts();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<List<PBPartialData>> snapshot) {
        if (snapshot.hasError) {
          Toasts.showError(snapshot.error.toString());
          if (_isLoading == false) {
            _isLoading = true;
          }
        } else if (snapshot.hasData && snapshot.data != null) {
          _contacts = snapshot.data!;
          if (_isLoading == true) {
            _isLoading = false;
          }
        }

        return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.grey[850],
            title: Text('Contacts'),
            centerTitle: true,
            actions: _isLoading
                ? null
                : _isEditting
                    ? [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            setState(() {
                              _isEditting = false;
                            });
                          },
                        )
                      ]
                    : [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Create(),
                              ),
                            );

                            // Update Contacts
                            setState(() {
                              _future = API.getContacts();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.manage_accounts),
                          onPressed: () {
                            setState(() {
                              _selected = [];
                              _isEditting = true;
                            });
                          },
                        ),
                      ],
          ),
          body: Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      final thisContact = _contacts[index];
                      return ListTile(
                        horizontalTitleGap: 5,
                        leading: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        ),
                        title: Text(
                          '${thisContact.first_name} ${thisContact.last_name}',
                          style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 18,
                              letterSpacing: 1),
                        ),
                        trailing: _isEditting
                            ? Icon(
                                _selected.contains(thisContact.id)
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Colors.lightBlue)
                            : null,
                        onTap: () async {
                          if (_isEditting) {
                            setState(() {
                              if (_selected.contains(thisContact.id)) {
                                _selected.remove(thisContact.id);
                              } else {
                                _selected.add(thisContact.id!);
                              }
                            });
                          } else {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => View(
                                  id: thisContact.id!,
                                ),
                              ),
                            );

                            // Update Contacts
                            setState(() {
                              _future = API.getContacts();
                            });
                          }
                        },
                      );
                    },
                  ),
          ),
          floatingActionButton: !_isLoading &&
                  _isEditting &&
                  _selected.length > 0
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (builder) {
                        return CupertinoAlertDialog(
                          title: Text(
                            'Delete Contacts',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isEditting = false;
                                  _contacts.removeWhere(
                                      (e) => _selected.contains(e.id));
                                });
                                Navigator.of(context).pop();
                                try {
                                  final result = await API.deleteContacts(
                                      _selected
                                          .map((e) => PBPartialData(id: e))
                                          .toList());

                                  // Update Contacts
                                  setState(() {
                                    _future = API.getContacts();
                                  });

                                  Toasts.showMessage(result);
                                } catch (error) {
                                  Toasts.showMessage(error.toString());
                                }
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white60,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
