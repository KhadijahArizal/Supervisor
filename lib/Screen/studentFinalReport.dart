import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SFinalReport extends StatefulWidget {
  const SFinalReport({super.key, required this.title});
  final String title;
  @override
  _SFinalReportState createState() => _SFinalReportState();
}

class _SFinalReportState extends State<SFinalReport> {
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
            'Final Report Status',
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
                Column(
                  children: [
                    Column(children: <Widget>[
                      TextField(
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black12,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90),
                                borderSide: BorderSide.none),
                            hintText: "search student Name/Matric No",
                            prefixIcon: const Icon(Icons.search_rounded),
                            prefixIconColor: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

