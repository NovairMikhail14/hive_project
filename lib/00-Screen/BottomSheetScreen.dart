import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_project/01-Data/User.dart';

class BottomSheetScreen extends StatefulWidget {
  BuildContext ctx;
  int? idindex;
  String? title ;
  String? description;
  // int idindex;
  BottomSheetScreen({required this.ctx,this.idindex,this.title,this.description});

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  var _TextEditTitle = new TextEditingController();
  var _TextEditDescription = new TextEditingController();
  late  Box box;

  @override
  void initState() {
    box = Hive.box<Map<dynamic,dynamic>>("HiveDB");
    setState(() {
      _TextEditTitle.text =widget.title??"";
      _TextEditDescription.text =widget.description??"";
    });

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(widget.ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Edit Task",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 5,
                      color: Colors.grey,
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Title",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  TextField(
                    controller: _TextEditTitle,
                    decoration: InputDecoration(
                        hintText: "Task title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      "Description",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  TextField(
                    controller: _TextEditDescription,
                    maxLines: 5,
                    style: TextStyle(),
                    decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var mapping = Map<dynamic ,dynamic>();
                      mapping["title"] = _TextEditTitle.text;
                      mapping["description"] = _TextEditDescription.text;
                      mapping["checkbox"] = false;
                      // User user =User(title:  _TextEditTitle.text, Description: _TextEditDescription.text);
                      widget.title == null?  box.add(mapping) :box.putAt(widget.idindex!,{"title": _TextEditTitle.text,"description":_TextEditDescription.text,"checkbox":false}) ;

                      // print(box.getAt(0));
                      Navigator.pop(context);
                    },
                    child: Text(widget.title == null? "Save":"Edit" ),
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size.fromWidth(150)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
