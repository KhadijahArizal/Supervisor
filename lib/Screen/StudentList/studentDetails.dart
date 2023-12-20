import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/StudentList/feedback.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails(
      {Key? key,
      required this.title,
      required this.studentName,
      required this.Matric,
      required this.onStatusChanged,
      required this.status})
      : super(key: key);

  final String title, studentName, Matric, status;
  final Function(String) onStatusChanged;

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  late String _studentName;
  late String _matric;
  late String _selectedStatusF;
  late List<String> _selectedStatusList;
  late List<String> _feedbackList;

  void _updateFeedback(int rowIndex, String feedback) {
    setState(() {
      _feedbackList[rowIndex] = feedback;
    });
  }

  @override
  void initState() {
    super.initState();
    _studentName = widget.studentName;
    _matric = widget.Matric;
    _selectedStatusF = ['Approved', 'Pending'].contains(widget.status)
        ? widget.status
        : 'Pending';
    _selectedStatusList = List.generate(2, (index) => 'Pending');
    _feedbackList = List.generate(2, (index) => '');
  }

  Widget _name({required String name}) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(name,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontFamily: 'Futura',
                    fontWeight: FontWeight.bold))
          ],
        ),
      );

  Widget _matricNo({required String matricNo}) => Container(
        child: Column(
          children: [
            Text(
              matricNo,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  DateTime selectedDate = DateTime.now();
  DateTime endDate = DateTime(2040);

  Widget _statusDropdownM(int rowIndex) {
    return DropdownButton<String>(
      value: _selectedStatusList[rowIndex],
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedStatusList[rowIndex] = newValue;
          });
          widget.onStatusChanged(newValue);
        }
      },
      items: <String>['Approved', 'Pending']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DataRow _buildDataRow(int rowIndex) {
    return DataRow(
      cells: [
        DataCell(Text('Week ${rowIndex + 1}')),
        const DataCell(Text('date')),
        DataCell(_statusDropdownM(rowIndex)),
        DataCell(
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(148, 112, 18, 2),
              ),
              child: const Text(
                "View Report",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackPage(
                        studentName: _studentName,
                        Matric: _matric,
                        onFeedbackSaved: (feedback) =>
                            _updateFeedback(rowIndex, feedback)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _feedbackList[rowIndex].isNotEmpty
                    ? Colors.green[700]
                    : Colors.yellow[700],
              ),
              child:
                  const Text("Feedback", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        DataCell(
          Text(
            _feedbackList[rowIndex],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusDropdownF() {
    return DropdownButton<String>(
      value: _selectedStatusF,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedStatusF = newValue;
          });
          widget.onStatusChanged(newValue);
        }
      },
      items: <String>['Approved', 'Pending']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                size: 25,
                Icons.arrow_back_ios_new_rounded,
                color:
                    Colors.black87.withOpacity(0.7), // Use the specified color
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
              color: Color.fromRGBO(148, 112, 18, 1),
              size: 30,
            )),
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: const AssetImage('assets/iiumlogo.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white30.withOpacity(0.2), BlendMode.dstATop),
                ),
              ),
              child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Name',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          )),
                                      _name(name: _studentName),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Matric No',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54)),
                                      _matricNo(matricNo: _matric),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                        const SizedBox(height: 10),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        const Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Monthly Report Submission',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black54)),
                            ],
                          )
                        ]),
                        const SizedBox(height: 7),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: (Row(children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    child: DataTable(
                                      dataRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white12),
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromRGBO(
                                                  148, 112, 18, 2)),
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Monthly Report History',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Date Submission',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Status',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'File',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Type Feedback',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Feedback Comment',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        _buildDataRow(0),
                                        _buildDataRow(1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]))),
                        const SizedBox(height: 20),
                        
                        //FINAL REPORT SAMPLE
                        SingleChildScrollView(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Final Report Submission',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54)),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow[700],
                                        ),
                                        child: const Text("No file",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ]),
                              const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Date Submission',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54)),
                                    SizedBox(height: 5),
                                    Text('date')
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Status',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54)),
                                    const SizedBox(height: 5),
                                    _statusDropdownF(),
                                  ])
                            ]))
                      ])))),
        ));
  }
}
