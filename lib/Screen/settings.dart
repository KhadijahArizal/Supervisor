import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required String title}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            color: Colors.black87.withOpacity(0.7),// Use the specified color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
            title: const Text(
              'Settings',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Futura'),
            ),
            backgroundColor: Colors.white70,
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
                                      _name(name: 'Zahra Fathanah'),
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
                                      _matricNo(matricNo: '2019050'),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                        const Divider(),
                        const SizedBox(height: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: 'Futura'),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                  height: 55,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: Colors.black38)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () => _startDate(context),
                                        icon: const Icon(Icons.date_range,
                                            color: Colors.black38),
                                      ),
                                      const SizedBox(width: 10),
                                      Text("${selectedDate.toLocal()}"
                                          .split(' ')[0]),
                                    ],
                                  ))
                            ]),
                        const SizedBox(height: 15),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'End Date',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: 'Futura'),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                  height: 55,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: Colors.black38)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () => _endDate(context),
                                        icon: const Icon(Icons.date_range,
                                            color: Colors.black38),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                          "${endDate.toLocal()}".split(' ')[0]),
                                    ],
                                  ))
                            ]),
                        const SizedBox(height: 30),
                        Container(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red[800],
                            ),
                            child: const Text('Instructions',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontFamily: 'Futura',
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(height: 5),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      const TextSpan(
                                        text: '1. ',
                                      ),
                                      TextSpan(
                                          text: 'IMPORTANT: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[800])),
                                      const TextSpan(
                                        text: 'Read the ',
                                      ),
                                      const TextSpan(
                                          text: 'FAQ Section ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                        text:
                                            'on procedures of IAP Cover Letter first before generating the Cover Letter ',
                                      ),
                                    ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: const TextSpan(
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      TextSpan(
                                        text: '2. Print the letter using a ',
                                      ),
                                      TextSpan(
                                          text: 'laser print ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: 'on  ',
                                      ),
                                      TextSpan(
                                          text: 'A4 ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: 'size ',
                                      ),
                                      TextSpan(
                                          text: '(80gsm).',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: const TextSpan(
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      TextSpan(
                                        text:
                                            '3. The department will not responsible for any incorrect information that you make, especially the ',
                                      ),
                                      TextSpan(
                                          text: 'START',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: 'and  ',
                                      ),
                                      TextSpan(
                                          text: 'END ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: 'dates.',
                                      ),
                                    ])),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(148, 112, 18, 1),
                                    ),
                                    icon: const Icon(Icons
                                        .email), //icon data for elevated button
                                    label: const Text("Save"), //label text
                                  ))
                            ])
                      ])))),
        ));
  }

}
