import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  final _formKey = GlobalKey<FormState>();
  DateTime _currentDate = DateTime.now();
  String phoneNo;
  int holder = 977;
  // ScreenSizeConfig().init(context);
  @override
  Widget build(BuildContext context) {
    String _formattedate = new DateFormat.yMMMd().format(_currentDate);
    Future<Null> _selectdate(BuildContext context) async {
      final DateTime _seldate = await showDatePicker(
          context: context,
          initialDate: _currentDate,
          firstDate: _currentDate,
          lastDate: DateTime(2021),
          builder: (context, child) {
            return SingleChildScrollView(child: child);
          });
      if (_seldate != null) {
        setState(() {
          _currentDate = _seldate;
        });
      }
    }

    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          // appBar: customAppBar(context, 'BookNow'),
          body: SingleChildScrollView(
            // padding: EdgeInsets.symmetric(horizontal: 3),
            child: Center(
              child: Container(
                // margin: EdgeInsets.only(bottom: 40),
                padding: EdgeInsets.symmetric(horizontal: 10),
                // height: MediaQuery.of(context).size.height / 1.08,
                color: Theme.of(context).primaryColor,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(18.0),
                //   border: Border.all(color: Colors.grey, width: 3),
                // ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Book Your's Now",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                          height: 2.4),
                    ),
                    Divider(
                      height: 80,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 100),
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                      // padding: EdgeInsets.only(bottom:17.0),
                      // height: MediaQuery.of(context).size.height/1.2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(width: 2, color: Colors.red),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 9.0,
                                spreadRadius: 8.0,
                                offset: Offset(4, 7))
                          ]),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                // border: Border.al,,
                                labelText: 'Name'),
                            validator: (name) {
                              if (name.isEmpty) {
                                return "Enter your name";
                              }
                              return null;
                            },
                          ),
                          Divider(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Email',
                                hintText: 'name@example.com'),
                            validator: (email) {
                              if (email.isEmpty) {
                                return "Enter your email";
                              }
                              return null;
                            },
                          ),
                          Divider(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Country',
                                hintText: 'Nepal'),
                            validator: (country) {
                              if (country.isEmpty) {
                                return "Enter country name";
                              }
                              return null;
                            },
                          ),
                          Divider(height: 20),
                          CountryPickerDropdown(
                            initialValue: 'np',
                            itemBuilder: _builderDropdownItem,
                            onValuePicked: (Country country) {
                              setState(() {
                                holder = int.parse(country.phoneCode);
                              });
                            },
                          ),
                          new TextFormField(
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                            keyboardType: TextInputType.phone,
                            validator: validateMobile,
                            decoration: new InputDecoration(
                              hintText: 'Phone No.',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .merge(
                                    TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                UiIcons.smartphone,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            onChanged: (value) {
                              this.phoneNo = "+" + holder.toString() + value;
                              print(phoneNo);
                            },
                          ),
                          Divider(height: 20),
                          InkWell(
                            onTap: () {
                              _selectdate(context);
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).accentColor,
                                size: 30.0,
                              ),
                              title: Text("$_formattedate",
                                  style: TextStyle(fontSize: 18.0)),
                            ),
                            // child: Row(
                            //   children: <Widget>[
                            //     IconButton(
                            //       icon: Icon(
                            //         Icons.calendar_today,
                            //         color: Theme.of(context).accentColor,
                            //         size: 30.0,
                            //       ),
                            //       onPressed: () {
                            //         _selectdate(context);
                            //       },
                            //     ),
                            //     Text(
                            //       '$_formattedate',
                            //       style: TextStyle(fontSize: 18.0),
                            //     )
                            //   ],
                            // ),
                          ),
                          Divider(height: 40),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.red)
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                print('Everything is done !!!');
                              } else {
                                return print("Somethings not right");
                              }
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 21.0,
                                // color: Theme.of(context).buttonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builderDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 2.0),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

  String validateMobile(String phoneNo) {
    if (phoneNo.length != 10)
      return "Entered Number must be of 10 digit";
    else
      return null;
  }
}
