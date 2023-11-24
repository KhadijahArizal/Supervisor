import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/Announcements/thisUpload.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController title = TextEditingController();
  //TextEditingController date = TextEditingController();
  TextEditingController informationController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Upload Announcement',
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
        ),
        leading: IconButton(
          icon: Icon(
            size: 25,
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87.withOpacity(0.7), // Use the specified color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                Colors.white30.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Title',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Futura')),
                          Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextFormField(
                                controller: title,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              )),
                        ]),
                    const SizedBox(height: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
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
                                  border: Border.all(color: Colors.black38)),
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
                    const SizedBox(height: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Media',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontFamily: 'Futura'),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.file_present_rounded,
                                      color: Color.fromRGBO(148, 112, 18, 1)),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Attach File',
                                  style: TextStyle(
                                      color: Color.fromRGBO(148, 112, 18, 1),
                                      fontSize: 17,
                                      fontFamily: 'Futura'),
                                  textAlign: TextAlign.right,
                                ),
                              ])
                        ]),
                    const SizedBox(height: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Information',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Futura')),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            height: 150,
                            child: TextFormField(
                              controller: informationController,
                              expands: true,
                              maxLines: null,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ]),
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          //Navigator.pop(context, informationController.text);
                          ThisUpload newUpload = ThisUpload(
                            title: title.text,
                            info: informationController.text,
                          );
                          Navigator.pop(context, newUpload);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(148, 112, 18, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius as needed
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 25.0,
                          ),
                        ),
                        child: const Text("Upload"), // Label text
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
