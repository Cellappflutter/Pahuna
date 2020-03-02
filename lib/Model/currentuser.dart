class CurrentUserInfo {
  String name="Name";
  int age=18;
  List<dynamic> continent = List<dynamic>();
  List<dynamic> interest = List<dynamic>();
  List<dynamic> matchPrefs = List<dynamic>();
  String gender= "Female";
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
