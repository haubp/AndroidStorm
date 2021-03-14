import "package:flutter/material.dart";

class FileInfo {
  bool selecting;
  double tabs;
  String filePath;

  FileInfo(this.selecting, this.tabs, this.filePath);
}

class File extends StatefulWidget {
  final void Function(String, bool) callbackOnPressed;
  final FileInfo info;

  File(this.info, this.callbackOnPressed);

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
        IconButton(
          icon: widget.info.selecting
              ? Icon(Icons.zoom_out)
              : Icon(Icons.zoom_in),
          onPressed: () {
            widget.callbackOnPressed(widget.info.filePath, widget.info.selecting);
          },
        ),
        SizedBox(width: 7),
        Icon(Icons.folder),
        SizedBox(width: 5),
        Text(widget.info.filePath),
      ],
    );
  }
}
