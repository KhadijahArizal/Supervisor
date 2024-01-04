class MonthlyReport {
  final String month;
  final String monthlyRname;
  final String status;
  final String date;
  final String monthlyFile;

  MonthlyReport({
    required this.month,
    required this.monthlyRname,
    required this.status,
    required this.date,
    required this.monthlyFile,
  });

}

class UserData {
  final String matric;
  final String name;
  final String studentID;
  final String svemail;
  final List<MonthlyReport> monthlyReports;
  final FinalReport finalReport;

  UserData({
    required this.studentID,
    required this.matric,
    required this.name,
    required this.svemail,
    required this.monthlyReports,
    required this.finalReport,
  });
}

class FinalReport {
  final String date;
  final String file;
  final String fileName;
  final String title;
  final String status;

  FinalReport({
    required this.date,
    required this.file,
    required this.fileName,
    required this.title,
    required this.status,
  });
}


