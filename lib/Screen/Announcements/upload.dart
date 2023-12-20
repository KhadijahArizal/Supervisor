import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:supervisor/Screen/Announcements/thisUpload.dart';

class Upload extends StatefulWidget {
  const Upload({super.key, this.onFileSelected});

  final void Function(String fileName)? onFileSelected;

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  late TextEditingController _fileNameController;
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController informationController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  //RealtimeDatabase
  final announcdb = FirebaseDatabase.instance.ref('Announcements');

  @override
  void initState() {
    super.initState();
    _fileNameController = TextEditingController(text: "-");
    date.text = DateFormat('dd MMMM yyyy').format(selectedDate);
  }

  Widget _File({
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.file_present_rounded,
          size: 28, color: Color.fromRGBO(148, 112, 18, 1)),
    );
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}');

        setState(() {
          _fileNameController.text = result.files.first.name;
        });

        widget.onFileSelected?.call(file.name);
      }
    } catch (e) {
      print('Error picking a file: $e');
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
                          const Text(
                            'Title',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontFamily: 'Futura'),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                title.text = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              fillColor: Colors.grey[100],
                              filled: true,
                              hintText: 'title',
                              prefixIcon: const Icon(Icons.person_rounded),
                            ),
                          )
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
                          TextFormField(
                            controller: date,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              fillColor: Colors.grey[100],
                              filled: true,
                              prefixIcon: const Icon(Icons.date_range_rounded),
                            ),
                            readOnly: true,
                          ),
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
                                _File(onTap: _pickFile),
                                const SizedBox(width: 5),
                                const Text(
                                  'Attach File',
                                  style: TextStyle(
                                      color: Color.fromRGBO(148, 112, 18, 1),
                                      fontSize: 17,
                                      fontFamily: 'Futura'),
                                  textAlign: TextAlign.right,
                                ),
                              ]),
                          Text(
                            _fileNameController.text.isNotEmpty
                                ? 'Selected File: ${_fileNameController.text}'
                                : '',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green[700],
                            ),
                            textAlign: TextAlign.left,
                          ),
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
                                onChanged: (value) {
                                  setState(() {
                                    informationController.text = value;
                                  });
                                },
                                expands: true,
                                maxLines: null,
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                ),
                              )),
                        ]),
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          announcdb.push().set({
                            'Announcement Title': title.text,
                            'Date': date.text,
                            'Media': _fileNameController.text,
                            'Information': informationController.text,
                          });

                          ThisUpload newUpload = ThisUpload(
                            title: title.text,
                            info: informationController.text,
                            fileName: _fileNameController.text,
                            date: date.text
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
                        child: const Text("Upload",
                            style:
                                TextStyle(color: Colors.white)), // Label text
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
