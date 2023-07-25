class TimeLogs {
  final int login;
  final String employeeid;
  final String type;
  final String date;
  final String time;
  final String latitude;
  final String longitude;

  TimeLogs(this.login, this.employeeid, this.type, this.date, this.time,
      this.latitude, this.longitude);

  factory TimeLogs.fromJson(Map<String, dynamic> json) {
    return TimeLogs(json['logid'], json['employeeid'], json['type'],
        json['date'], json['time'], json['latitude'], json['longitude']);
  }
}
