class MonthlyReportC {
  final String month;
  final String monthlyRname;
  final String status;
  final String date;
  final String monthlyFile;

  MonthlyReportC({
    required this.month,
    required this.monthlyRname,
    required this.status,
    required this.date,
    required this.monthlyFile,
  });

}

class UserDataC {
  final String matric;
  final String name;
  final String studentID;
  final String svemail;
  final List<MonthlyReportC> monthlyReports;
  final FinalReportC finalReport;

  UserDataC({
    required this.studentID,
    required this.matric,
    required this.name,
    required this.svemail,
    required this.monthlyReports,
    required this.finalReport,
  });
}

class UserDataS {
  final String matric;
  final String name;
  final String studentID;
  final String svemail;

  UserDataS({
    required this.studentID,
    required this.matric,
    required this.name,
    required this.svemail,
  });
}

class FinalReportC {
  final String date;
  final String file;
  final String fileName;
  final String title;
  final String status;

  FinalReportC({
    required this.date,
    required this.file,
    required this.fileName,
    required this.title,
    required this.status,
  });
}


