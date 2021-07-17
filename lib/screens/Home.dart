import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/modules/API.dart';
import 'package:phonebook/screens/Create.dart';
import 'package:phonebook/screens/View.dart';
import 'package:phonebook/structures/PBPartialData.dart';
import 'package:phonebook/utils/Toasts.dart';

Stream<List<PBPartialData>> contacts() async* {
  yield* Stream.periodic(Duration(seconds: 3), (_) async {
    return await API.getContacts();
  }).asyncMap((event) async => await event);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;
  bool _isEditting = false;
  List<PBPartialData> _contacts = [];
  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: contacts(),
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
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Create(),
                              ),
                            );
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
                      final this_data = _contacts[index];
                      return ListTile(
                        horizontalTitleGap: 5,
                        leading: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        ),
                        title: Text(
                          '${this_data.first_name} ${this_data.last_name}',
                          style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 18,
                              letterSpacing: 1),
                        ),
                        trailing: _isEditting
                            ? Icon(
                                _selected.contains(this_data.id)
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Colors.lightBlue)
                            : null,
                        onTap: () {
                          if (_isEditting) {
                            setState(() {
                              if (_selected.contains(this_data.id)) {
                                _selected.remove(this_data.id);
                              } else {
                                _selected.add(this_data.id!);
                              }
                            });
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => View(
                                  id: this_data.id!,
                                ),
                              ),
                            );
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
                                Navigator.pop(context);
                                try {
                                  final result = await API.deleteContacts(
                                      _selected
                                          .map((e) => PBPartialData(id: e))
                                          .toList());

                                  Toasts.showMessage(
                                      '$result contact${result > 1 ? 's' : ''} deleted');
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
                                Navigator.pop(context);
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
