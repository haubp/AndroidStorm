import 'package:flutter/material.dart';
import 'file.dart';

class FileExplorer extends StatefulWidget {
  final List<FileInfo> filesTree;
  final void Function(String, bool) update;

  FileExplorer(this.filesTree, this.update);

  @override
  _FileExplorerState createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.filesTree.length,
      itemBuilder: (BuildContext context, int index) {
        return File(widget.filesTree[index], widget.update);
      },
    );
  }
}
