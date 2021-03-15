import "package:flutter/material.dart";

class FileInfo {
  bool selecting;
  double tabs;
  String filePath;
  bool checkValue;

  FileInfo(this.selecting, this.tabs, this.filePath, this.checkValue);
}

class File extends StatefulWidget {
  final void Function(String, bool) callbackOnPressed;
  final void Function(String, bool) callbackOnChecked;
  final FileInfo info;

  File(this.info, this.callbackOnPressed, this.callbackOnChecked);

  @override
  _FileState createState() => _FileState();
}

class _FileState extends State<File> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.info.tabs * 10,
        ),
        Checkbox(
            value: widget.info.checkValue,
            onChanged: (bool check) {
              setState(() {
                widget.info.checkValue = !widget.info.checkValue;
                widget.callbackOnChecked(
                    widget.info.filePath, widget.info.checkValue);
              });
            }),
        SizedBox(
          width: 5,
        ),
        IconButton(
          icon: widget.info.selecting
              ? Icon(Icons.zoom_out)
              : Icon(Icons.zoom_in),
          onPressed: () {
            widget.callbackOnPressed(
                widget.info.filePath, widget.info.selecting);
          },
        ),
        SizedBox(width: 4),
        Icon(Icons.folder),
        SizedBox(width: 5),
        Text(widget.info.filePath.split('/').last),
      ],
    );
  }
}
