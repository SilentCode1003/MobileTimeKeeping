class Employee {
  final String employeeid;
  final String firstname;
  final String middlename;
  final String lastname;
  final String username;
  final String password;
  final String position;
  final String department;
  final String contactnumber;
  final String email;
  final String status;

  Employee(
      this.employeeid,
      this.firstname,
      this.middlename,
      this.lastname,
      this.username,
      this.password,
      this.position,
      this.department,
      this.contactnumber,
      this.email,
      this.status);

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        json['employeeid'],
        json['firstname'],
        json['middlename'],
        json['lastname'],
        json['username'],
        json['password'],
        json['position'],
        json['department'],
        json['contactnumber'],
        json['email'],
        json['status']);
  }
}
