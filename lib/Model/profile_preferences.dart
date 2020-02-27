class ProfileMatchPreferences {
  final List<String> preferences = [
    "Travel",
    "Dinner",
    "Hangout",
    "X1",
    "X2",
  ];
  final List<int> colors = [
    0xFF4fc3f7,
    0xFFffb74d,
    0xffff8a65,
    0xff9575cd,
    // 0xff4db6ac,
    0xfff06292,
    // 0xffa1887f,
    // 0xFF90a4ae,
    // 0xFFba68c8
  ];
  final List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    //false,
    // false,
    // false,
    // false
  ];
}

class ProfileContinentPreferences {
  final List<String> preferences = [
    "Asian",
    "European",
    "African",
    "X1",
    "X2",
  ];
  final List<int> colors = [
    // 0xFF4fc3f7,
    0xFFffb74d,
    //0xffff8a65,
    0xff9575cd,
    0xff4db6ac,
    //0xfff06292,
    0xffa1887f,
    // 0xFF90a4ae,
    0xFFba68c8
  ];
  final List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    // false,
    // false,
    // false,
    // false
  ];
}

class ProfileInterestPreferences {
  final List<String> preferences = [
    "Travel",
    "Dinner",
    "Hangout",
    "X1",
    "X2",
  ];
  final List<int> colors = [
    // 0xFF4fc3f7,
    0xFFffb74d,
    0xffff8a65,
    //0xff9575cd,
    0xff4db6ac,
    0xfff06292,
    //  0xffa1887f,
    0xFF90a4ae,
    //0xFFba68c8
  ];
  final List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    // false,
    // false,
    // false,
    // false
  ];
}

class SearchPrefsdata {
  List<dynamic> matchPrefs = List<dynamic>();
  List<dynamic> interest = List<dynamic>();
  List<dynamic> continent = List<dynamic>();
  double range;
}
