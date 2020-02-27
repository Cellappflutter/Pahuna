class CurrentUserInfo {
  String name;
  int age;
  List<dynamic> continent = List<dynamic>();
  List<dynamic> interest = List<dynamic>();
  List<dynamic> matchPrefs = List<dynamic>();
  String gender;
  String uid;
  String avatar;
  CurrentUserInfo(
      {this.uid,
      this.name,
      this.age,
      this.gender,
      this.continent,
      this.interest,
      this.avatar,
      this.matchPrefs});
}
