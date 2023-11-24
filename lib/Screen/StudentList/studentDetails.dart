import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/StudentList/feedback.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails(
      {Key? key,
      required this.title,
      required this.studentName,
      required this.Matric,
      required this.status})
      : super(key: key);

  final String title;
  final String studentName;
  final String Matric;
  final String status;

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  late String _studentName;
  late String _matric;

  @override
  void initState() {
    super.initState();
    _studentName = widget.studentName;
    _matric = widget.Matric;
  }

  final String _statuss = 'Approved';

  Widget _status() {
    Color? statusColor =
        _statuss == 'Approved' ? Colors.green[700] : Colors.yellow[700];
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _statuss, // Use the updated status here
            style: TextStyle(
              color: statusColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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

  Future<void> _startDate(BuildContext context) async {
    final DateTime? spicked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2040));
    if (spicked != null && spicked != selectedDate) {
      setState(() {
        selectedDate = spicked;
      });
    }
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023),
        lastDate: endDate);
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
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
                                            'Feedback',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        DataRow(
                                          cells: [
                                            const DataCell(Text('Week 1')),
                                            const DataCell(Text('date')),
                                            DataCell(Container(
                                                child: Text(
                                                    _statuss))), //STATUS APPROVED OR PENDING
                                            DataCell(
                                              Container(
                                                alignment: Alignment.center,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 21, 108, 24),
                                                  ),
                                                  child:
                                                      const Text("View Report"),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                alignment: Alignment.center,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 21, 108, 24),
                                                  ),
                                                  child: Text('Feedback'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        DataRow(
                                          cells: [
                                            const DataCell(Text('Week 2')),
                                            const DataCell(Text('date')),
                                            DataCell(Text('Pending')),
                                            DataCell(
                                              Container(
                                                alignment: Alignment.center,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.yellow[700],
                                                  ),
                                                  child:
                                                      const Text("View Report"),
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
                                                          builder: (context) =>
                                                              FeedbackPage()),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.yellow[700],
                                                  ),
                                                  child: const Text("Feedback"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // more rows
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]))),
                        const SizedBox(height: 20),
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
                                        child: const Text("No file"),
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
                                    Text(_statuss)
                                  ])
                            ]))
                      ])))),
        ));
  }
}
