import 'package:flutter/material.dart';

class App {
  BuildContext _context;
  double _height;
  double _width;
  double _heightPadding;
  double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height - ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding = _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding * v;
  }
}

class Colors {
  Color _mainColor = Color.fromRGBO(216, 48, 48, 1);
  Color _mainDarkColor =  Color.fromRGBO(216, 40, 32, 1);
  Color _secondColor = Color.fromRGBO(208, 72, 80, 1);
  Color _secondDarkColor = Color.fromRGBO(216, 40, 32, 1);//Color(0xFFE7F6F8);
  Color _accentColor = Color.fromRGBO(216, 40, 32, 1);//Color(0xFFADC4C8);
  Color _accentDarkColor = Color.fromRGBO(216, 40, 32, 1);//Color(0xFFADC4C8);
  Color _whiteColor = Color(0xFFFFFF);
  //Color _mainAppColor= Color(0xffdd2827);
  Color _yellowColor = Color.fromRGBO(255, 255, 0, 1);

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color whiteColor(double opacity) {
    return this._whiteColor.withOpacity(opacity);
  }

  Color yellowColor(double opacity) {
    return this._yellowColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }
}
