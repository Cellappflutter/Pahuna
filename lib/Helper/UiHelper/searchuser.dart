import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';

class SearchUserForm extends StatefulWidget {
  final DataCallback callback;
  SearchUserForm({this.callback});
  @override
  _SearchUserFormState createState() => _SearchUserFormState();
}

typedef void DataCallback(SearchPrefsdata searchPrefsdata);

class _SearchUserFormState extends State<SearchUserForm> {
  ProfileContinentPreferences continents = ProfileContinentPreferences();
  ProfileMatchPreferences interests = ProfileMatchPreferences();
  double range = 8.0;
  bool boy = false;
  bool girl = false;
  bool any = false;
  bool group = false;
  bool couple = false;
  List<dynamic> matchPrefs = List<dynamic>(); //girl,boy
  List<dynamic> interest = List<dynamic>(); //dinner,hang
  List<dynamic> continent = List<dynamic>(); //asian, euro
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Match Preference : ',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Wrap(
            children: <Widget>[
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text('Girl'),
                  Checkbox(
                    value: girl,
                    onChanged: (bool value) {
                      if (value) {
                        matchPrefs.add("Girl");
                      } else {
                        matchPrefs.remove("Girl");
                      }
                      setState(() {
                        girl = value;
                      });
                    },
                  ),
                ]),
                widthBox(),
                Text('Boy'),
                Checkbox(
                  value: boy,
                  onChanged: (bool value) {
                    if (value) {
                      matchPrefs.add("Boy");
                    } else {
                      matchPrefs.remove("Boy");
                    }
                    setState(() {
                      boy = value;
                    });
                  },
                ),
              ]),
              widthBox(),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('Group'),
                Checkbox(
                  value: group,
                  onChanged: (bool value) {
                    if (value) {
                      matchPrefs.add("Group");
                    } else {
                      matchPrefs.remove("Group");
                    }
                    setState(() {
                      group = value;
                    });
                  },
                ),
              ]),
              widthBox(),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('Couple'),
                Checkbox(
                  value: couple,
                  onChanged: (bool value) {
                    if (value) {
                      matchPrefs.add("Couple");
                    } else {
                      matchPrefs.remove("Couple");
                    }
                    setState(() {
                      couple = value;
                    });
                  },
                ),
              ]),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          divider(context),
          SizedBox(
            height: 10.0,
          ),
          Wrap(
            children: interestchipDesign(),
          ),
          divider(context),
          SizedBox(
            height: 10.0,
          ),
          Wrap(
            children: continentschipDesign(),
          ),
          SizedBox(
            height: 30.0,
          ),
          Slider(
              value: range,
              max: 20,
              min: 4,
              activeColor: Colors.red,
              inactiveColor: Colors.red,
              label: range.toString(),
              divisions: 4,
              onChanged: (newValue) {
                setState(() {
                  range = newValue;
                });
              }),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 150,
              child: RaisedButton(
                  animationDuration: Duration(seconds: 10),
                  splashColor: Colors.red,
                  child: Text(
                    'Submit'.toUpperCase(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50)),
                  ),
                  color: Colors.brown,
                  textColor: Colors.black,
                  onPressed: () async {
                    if (validate()) {
                      insertData();
                    }
                  }),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  widthBox() {
    return SizedBox(
      width: ScreenSizeConfig.blockSizeHorizontal * 6,
    );
  }

  List<Widget> interestchipDesign() {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < interests.preferences.length; i++) {
      Widget widget = Container(
        child: ChoiceChip(
          label: Text(interests.preferences[i],
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Color(interests.colors[i]),
          selected: interests.isSelected[i],
          pressElevation: 5.0,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            if (selected) {
              interest.add(interests.preferences[i]);
            } else {
              interest.remove(interests.preferences[i]);
            }
            setState(() {
              interests.isSelected[i] = !interests.isSelected[i];
            });
          },
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4.0),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      );
      widgets.add(widget);
    }
    return widgets;
  }

  List<Widget> continentschipDesign() {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < continents.preferences.length; i++) {
      Widget widget = Container(
        child: ChoiceChip(
          label: Text(continents.preferences[i],
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Color(continents.colors[i]),
          selected: continents.isSelected[i],
          pressElevation: 5.0,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            if (selected) {
              continent.add(continents.preferences[i]);
            } else {
              continent.remove(continents.preferences[i]);
            }
            setState(() {
              continents.isSelected[i] = !continents.isSelected[i];
            });
          },
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4.0),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      );
      widgets.add(widget);
    }
    return widgets;
  }

  Container divider(BuildContext context) => Container(
        child: Divider(),
      );

  insertData() {
    SearchPrefsdata searchPrefsdata = SearchPrefsdata();
    searchPrefsdata.matchPrefs = matchPrefs;
    searchPrefsdata.interest = interest;
    searchPrefsdata.continent = continent;
    searchPrefsdata.range = range;
    widget.callback(searchPrefsdata);
    Navigator.of(context).pop();
  }

  bool validate() {
    if ((matchPrefs.length > 0) &&
        (interest.length > 0) &&
        (continent.length > 0)) {
      return true;
    }
    return false;
  }
}
