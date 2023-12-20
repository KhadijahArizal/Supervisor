import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage(
      {Key? key,
      required this.studentName,
      required this.Matric,
      required this.onFeedbackSaved})
      : super(key: key);

  final String studentName, Matric;
  final Function(String) onFeedbackSaved;

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late String _studentName;
  late String _matric;
  String _feedbackText = '';
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;

  @override
  void initState() {
    super.initState();
    _studentName = widget.studentName;
    _matric = widget.Matric;
  }

  Widget _name({required String name}) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(name,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold))
        ],
      );

  Widget _matricNo({required String matricNo}) => Column(
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          'Monthly Task Feedback',
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveFeedback();
            },
          ),
        ],
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
                  Colors.white30.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      fontSize: 13, color: Colors.black54)),
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
                const SizedBox(height: 30),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(isBold
                          ? Icons.format_bold
                          : Icons.format_bold_outlined),
                      onPressed: () {
                        setState(() {
                          isBold = !isBold;
                        });
                        _applyTextStyle();
                      },
                    ),
                    IconButton(
                      icon: Icon(isItalic
                          ? Icons.format_italic
                          : Icons.format_italic_outlined),
                      onPressed: () {
                        setState(() {
                          isItalic = !isItalic;
                        });
                        _applyTextStyle();
                      },
                    ),
                    IconButton(
                      icon: Icon(isUnderline
                          ? Icons.format_underline
                          : Icons.format_underline_outlined),
                      onPressed: () {
                        setState(() {
                          isUnderline = !isUnderline;
                        });
                        _applyTextStyle();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Type your feedback here...',
                    ),
                    onChanged: (text) {
                      _applyTextStyle();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveFeedback() {
    String feedbackText = _textController.text;
    setState(() {
      _feedbackText = feedbackText;
    });
    widget.onFeedbackSaved(feedbackText);

    Navigator.pop(context);
  }

  void _applyTextStyle() {
    /* final TextStyle textStyle = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
    */
    _textController.value = _textController.value.copyWith(
      text: _textController.text,
      selection: TextSelection.collapsed(offset: _textController.text.length),
      composing: TextRange.empty,
    );
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
  }
}
