// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use, camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class S_Details extends StatefulWidget {
  S_Details({
    required this.matric,
    required this.name,
    required this.studentID,
    Key? key,
  }) : super(key: key);

  final String name, matric, studentID;

  @override
  _S_DetailsState createState() => _S_DetailsState();
}

class _S_DetailsState extends State<S_Details> {
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController feedbackControllerF = TextEditingController();
  String supervisorEmail = FirebaseAuth.instance.currentUser?.uid ?? '';
  String studentID = '';
  //Final Report
  late DatabaseReference _finalReport;
  late Future<List<FinalData1>> _userFinalFuture;
  //MOnthly
  late DatabaseReference _monthlyReport;
  late Future<List<MonthlyData1>> _userMonthlyFuture;

  @override
  void initState() {
    super.initState();
    studentID = widget.studentID;
    _finalReport =
        FirebaseDatabase.instance.ref('Student').child('Final Report');
    _userFinalFuture = _fetchFinalData(widget.studentID);
    _monthlyReport =
        FirebaseDatabase.instance.ref('Student').child('Monthly Report');
    _userMonthlyFuture = _fetchMonthlyData(widget.studentID);
  }

  Future<List<FinalData1>> _fetchFinalData(String studentID) async {
    List<FinalData1> userDataList = [];
    try {
      DataSnapshot finalReportSnapshot =
          await _finalReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? finalReportData =
          finalReportSnapshot.value as Map<dynamic, dynamic>?;

      if (finalReportData != null) {
        finalReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            String date = value['Date'] ?? '';
            String file = value['File'] ?? '';
            String fileName = value['File Name'] ?? '';
            String title = value['Report Title'] ?? '';
            String status = value['Status'] ?? '';
            String statusSV = value['StatusSV'] ?? '';
            String feedbackSV = value['FeedbackSV'] ?? '';

            if (key == studentID) {
              FinalData1 userF = FinalData1(
                  studentID: studentID,
                  date: date,
                  file: file,
                  fileName: fileName,
                  title: title,
                  status: status,
                  statusSV: statusSV,
                  feedbackSV: feedbackSV);
              userDataList.add(userF);
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  Future<List<MonthlyData1>> _fetchMonthlyData(String studentID) async {
    List<MonthlyData1> userDataList = [];
    try {
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;

      if (monthlyReportData != null) {
        monthlyReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            if (key == studentID) {
              List<MR> monthlyReports = [];

              if (monthlyReportData[key]['Reports'] is Map) {
                monthlyReportData[key]['Reports']
                    .forEach((reportKey, reportValue) {
                  MR monthlyReport = MR(
                    titleM: reportValue['Title'] ?? '',
                    month: reportValue['Month'] ?? '',
                    status: reportValue['Status'] ?? 'Pending',
                    date: reportValue['Submission Date'] ?? '',
                    monthlyReportLink: reportValue['Link'] ?? '',
                    reportsKey: reportValue['Report Key'] ?? '',
                    feedback: reportValue['Feedback'] ?? '',
                  );
                  monthlyReports.add(monthlyReport);
                });
              }

              MonthlyData1 monthlyData = MonthlyData1(
                key: key,
                studentID: studentID,
                monthlyReports: monthlyReports,
              );
              userDataList.add(monthlyData);
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  @override
  Widget build(BuildContext context) {
    print('TEST INI SIAPA ${widget.name} $studentID');
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color.fromRGBO(0, 146, 143, 10), size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: const AssetImage('assets/iiumlogo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white30.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailName('Name', widget.name),
                      _buildDetailMatric('Matric', widget.matric)
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: const Text(
                            'Monthly Report Submission',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          )),
                      const SizedBox(height: 10),
                      //Monthly
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: FutureBuilder<List<MonthlyData1>>(
                          future: _userMonthlyFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No data available.'));
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: DataTable(
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) {
                                      return const Color.fromRGBO(0, 146, 143,
                                          10); // Background color for the header row
                                    }),
                                    columnSpacing:
                                        40, // Adjust the spacing as needed
                                    dataRowHeight:
                                        50, // Adjust the height as needed
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Month',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Title',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Status',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: _buildTableRows(snapshot.data!),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      //Final
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExpansionTile(
                              title: const Text(
                                'Final Report Submission',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                FutureBuilder<List<FinalData1>>(
                                  future: _userFinalFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else {
                                      var userF =
                                          snapshot.data?.isNotEmpty == true
                                              ? snapshot.data![0]
                                              : null;

                                      if (userF != null) {
                                        return Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: _buildDetail(
                                                          'Report Title:',
                                                          userF.title,
                                                        )),
                                                    Expanded(
                                                      flex: 1,
                                                      child:
                                                          _buildStatusDropdownF(
                                                        statusSV:
                                                            userF.statusSV,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            userF.statusSV =
                                                                newValue!;
                                                            DatabaseReference
                                                                userRef =
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .ref(
                                                                        'Student')
                                                                    .child(
                                                                        'Final Report')
                                                                    .child(
                                                                        studentID);

                                                            userRef.update({
                                                              'StatusSV':
                                                                  newValue,
                                                            });
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                _buildDetail(
                                                  'File Name:',
                                                  userF.fileName,
                                                ),
                                                const SizedBox(height: 20),
                                                const SizedBox(height: 20),
                                                _buildDetail(
                                                    'Date:', userF.date),
                                                const SizedBox(height: 20),
                                                _buildDetailFeedback(
                                                    'Feedback:',
                                                    userF.feedbackSV)
                                              ],
                                            ));
                                      } else {
                                        return const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            'Final Report Has Not Been Submitted Yet',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildTableRows(List<MonthlyData1> data) {
    bool isColorRow = false;
    return data.expand((MR) {
      return MR.monthlyReports.map((report) {
        isColorRow = !isColorRow;
        return DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return isColorRow ? Colors.white : Colors.white;
          }),
          cells: [
            DataCell(
              Text(
                report.month,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataCell(
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Icon(Icons.file_open_rounded,
                          color: Color.fromRGBO(0, 146, 143, 10), size: 17),
                      const SizedBox(width: 5),
                      Text(report.titleM),
                    ],
                  )),
              onTap: () {
                _showDetailsPopup(report);
              },
            ),
            DataCell(
              _buildStatusDropdown(
                status: report.status,
                onChanged: (newValue) {
                  setState(() {
                    report.status = newValue!;
                    DatabaseReference userRef = FirebaseDatabase.instance
                        .ref('Student')
                        .child('Monthly Report')
                        .child(studentID)
                        .child('Reports')
                        .child(report.reportsKey);

                    userRef.update({
                      'Status': newValue,
                    });
                  });
                },
              ),
            ),
          ],
        );
      });
    }).toList();
  }

  Widget _buildDetailName(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget _buildDetailMatric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ],
    );
  }

  Future<void> _showFeedbackPopup(BuildContext context, MR report) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: TextFormField(
            controller: feedbackController,
            decoration: const InputDecoration(
              hintText: 'Enter your feedback...',
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the feedback popup
                DatabaseReference userRef = FirebaseDatabase.instance
                    .ref('Student')
                    .child('Monthly Report')
                    .child(studentID)
                    .child('Reports')
                    .child(report.reportsKey);

                userRef.update({
                  'Feedback':
                      feedbackController.text, // Get text from the controller
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                foregroundColor: Colors.black,
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFeedbackPopupFinal(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: TextFormField(
            controller: feedbackControllerF,
            decoration: const InputDecoration(
              hintText: 'Enter your feedback...',
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the feedback popup
                DatabaseReference userRef = FirebaseDatabase.instance
                    .ref('Student')
                    .child('Final Report')
                    .child(studentID);

                userRef.update({
                  'FeedbackSV':
                      feedbackControllerF.text, // Get text from the controller
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget _buildDetailFeedback(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Row(children: [
          ElevatedButton(
            onPressed: () {
              _showFeedbackPopupFinal(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[800],
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(100), // Set the border radius to 100
              ),
            ),
            child: const Text(
              'Type Feedback',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ]),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget _buildDetail2(String label, String value) {
    Color statusColor = _getStatusColor(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 15,
                  color: statusColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ],
    );
  }

  Widget _buildStatusDropdown({
    required String status,
    required void Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: status,
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down_rounded), // Add dropdown icon
          items:
              <String>['Approved', 'Pending', 'Rejected'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: _getStatusColor(value),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusDropdownF({
    required void Function(String?)? onChanged,
    required String statusSV,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Status',
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
        DropdownButton<String>(
          value: statusSV,
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down_rounded), // Add dropdown icon
          items:
              <String>['Approved', 'Pending', 'Rejected'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: _getStatusColor(value),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showDetailsPopup(MR report) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Monthly Report Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildDetail('Title:', report.titleM)],
                ),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Monthly Report',
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          _openPdfFile(context, report.monthlyReportLink);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(0, 146, 143, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                100), // Set the border radius to 100
                          ),
                        ),
                        child: const Text(
                          'View Report',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                      const SizedBox(width: 7),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          _showFeedbackPopup(context, report);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                100), // Set the border radius to 100
                          ),
                        ),
                        child: const Text(
                          'Type Feedback',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                    ]),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetail('Date:', report.date),
                    ),
                    Expanded(
                      child: _buildDetail2('Status:', report.status),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetail('Feedback:', report.feedback),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          100), // Set the border radius to 100
                    ),
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void _openPdfFile(BuildContext context, String? fileUrl) async {
    if (fileUrl != null && fileUrl.isNotEmpty) {
      try {
        await launch(fileUrl);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open the PDF file.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid PDF file URL.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.yellow[700]!;
      case 'Approved':
        return Colors.green[700]!;
      case 'Rejected':
        return Colors.red[700]!;
      default:
        return Colors.black87; // Default color
    }
  }
}

class MonthlyData1 {
  final String studentID;
  final String key;
  final List<MR> monthlyReports;

  MonthlyData1({
    required this.studentID,
    required this.key,
    required this.monthlyReports,
  });
}

class MR {
  final String month;
  final String titleM;
  final String monthlyReportLink;
  String status;
  String feedback;
  final String date;
  final String reportsKey;

  MR({
    required this.month,
    required this.titleM,
    required this.monthlyReportLink,
    required this.status,
    required this.feedback,
    required this.date,
    required this.reportsKey,
  });
}

class FinalData1 {
  final String date;
  final String file;
  final String fileName;
  final String title;
  final String status;
  final String studentID;
  String statusSV;
  String feedbackSV;

  FinalData1({
    required this.studentID,
    required this.date,
    required this.file,
    required this.fileName,
    required this.title,
    required this.status,
    required this.statusSV,
    required this.feedbackSV,
  });
}
