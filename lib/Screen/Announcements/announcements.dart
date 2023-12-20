import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/BottomNavBar/googleNavBar.dart';
import 'package:supervisor/Screen/Announcements/thisUpload.dart';
import 'package:supervisor/Screen/Announcements/upload.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class Announc extends StatefulWidget {
  const Announc({super.key, required this.title});
  final String title;

  @override
  _AnnouncState createState() => _AnnouncState();

  static void add(ThisUpload newUpload) {}
}

class _AnnouncState extends State<Announc> {
  int _currentIndex = 2;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/summary');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/student_list');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/announc');
      }
    });
  }

  Widget _buildCustomExpansionTile(int index, String title, String subtitle,
      String information, String fileName, String date) {
    return ExpansionTile(
      //Title
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontFamily: 'Futura',
        ),
      ),
      //Name
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 13,
          fontFamily: 'Futura',
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon:
                const Icon(Icons.edit, color: Color.fromRGBO(148, 112, 18, 1)),
            onPressed: () {
              _showEditDialog(index);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete,
                color: Color.fromRGBO(148, 112, 18, 1)),
            onPressed: () {
              _showDeleteDialog(index);
            },
          ),
        ],
      ),
      children: <Widget>[
        ListTile(
          leading: Text(
            information,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontFamily: 'Futura',
            ),
          ),
          title: Text(
            fileName,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontFamily: 'Futura',
            ),
            textAlign: TextAlign.end
          ),
          subtitle: Text(date,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontFamily: 'Futura',
              ),
              textAlign: TextAlign.end),
        )
      ],
      onExpansionChanged: (bool expanded) {
        setState(() {
          // Handle expansion change if needed
        });
      },
    );
  }

  void _showEditDialog(int index) {
    TextEditingController editTitleController =
        TextEditingController(text: announcements[index].title);
    TextEditingController editInfoController =
        TextEditingController(text: announcements[index].info);
    TextEditingController editFileName =
        TextEditingController(text: announcements[index].fileName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Edit Announcement",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                TextFormField(
                  controller: editTitleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: editFileName,
                  decoration: const InputDecoration(labelText: "File Name"),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: editInfoController,
                  maxLines: null,
                  decoration: const InputDecoration(labelText: "Information"),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color.fromRGBO(148, 112, 18, 1),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          announcements[index].title = editTitleController.text;
                          announcements[index].fileName = editFileName.text;
                          announcements[index].info = editInfoController.text;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save",
                          style: TextStyle(
                            color: Color.fromRGBO(148, 112, 18, 1),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Delete Announcement",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                const Text(
                    "Are you sure you want to delete this announcement?"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel",
                          style: TextStyle(
                              color: Color.fromRGBO(148, 112, 18, 1))),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          announcements.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Delete",
                          style: TextStyle(
                              color: Color.fromRGBO(148, 112, 18, 1))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<ThisUpload> announcements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Announcements',
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
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.sort,
                  color: Color.fromRGBO(148, 112, 18, 1), size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: sideNav(),
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
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 1.0)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //headline
                      const Text(
                        'Important Annoucements',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Futura',
                            fontWeight: FontWeight.w900),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: announcements.length,
                        itemBuilder: (context, index) {
                          return _buildCustomExpansionTile(
                            index,
                            '${announcements[index].title}',
                            'Dr.Ameera Binti Huseein',
                            '${announcements[index].info}',
                            '${announcements[index].fileName}',
                            '${announcements[index].date}',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GNavbar(
        currentIndex: _currentIndex,
        onTabChange: onTabTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ThisUpload? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Upload(),
            ),
          );
          if (result != null) {
            setState(() {
              announcements.add(result);
            });
          }
        },
        backgroundColor: const Color.fromRGBO(148, 112, 18, 0.8),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
