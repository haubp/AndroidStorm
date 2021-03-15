import 'package:flutter/material.dart';
import 'fileExplorer.dart';
import 'file.dart';

import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Map<String, Map> jsonTreeFormat = {};

  final List<FileInfo> filesTree = <FileInfo>[];

  MyHomePage({Key key}) : super(key: key) {
    Directory root = Directory('/Users/haubui/Documents');
    List<FileSystemEntity> files =
        root.listSync(recursive: true, followLinks: false);

    for (FileSystemEntity entry in files) {
      List<String> tmpLst = entry.path.replaceFirst('/', '').split('/');
      var tmp = jsonTreeFormat;
      for (var key in tmpLst) {
        if (!jsonTreeFormat.keys.contains(key)) tmp[key] = {};
        tmp = tmp[key];
      }
    }

    for (final entry in jsonTreeFormat.keys) {
      filesTree.add(FileInfo(false, 0, entry, false));
    }

    stderr.writeln(filesTree);
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container(child: FileExplorer(widget.filesTree, updateList, onCheck)),
    );
  }

  void onCheck(String filePath, bool value) {
    if (!value) {
      if (filePath.contains('/')) {
        var tmpLst = filePath.split('/');
        tmpLst.removeLast();

        String parentPath = tmpLst.join('/');

        int parentIndex = 0;

        for (int treeIndex = 0;
            treeIndex < widget.filesTree.length;
            treeIndex++) {
          if (widget.filesTree[treeIndex].filePath == parentPath) {
            parentIndex = treeIndex;
            break;
          }
        }

        int checkedChildCount = 0;

        stderr.writeln(parentPath);

        for (int treeIndex = parentIndex + 1;
            treeIndex < widget.filesTree.length;
            treeIndex++) {
          if (widget.filesTree[treeIndex].filePath.startsWith(parentPath)) {
            if (widget.filesTree[treeIndex].checkValue == true) {
              checkedChildCount++;
            }
          } else {
            break;
          }
        }

        stderr.writeln(checkedChildCount);

        if (checkedChildCount == 0) {
          widget.filesTree[parentIndex].checkValue = false;
        }
      }
    } else {
      int parentIndex = 0;

      for (int treeIndex = 0;
          treeIndex < widget.filesTree.length;
          treeIndex++) {
        if (widget.filesTree[treeIndex].filePath == filePath) {
          parentIndex = treeIndex;
          break;
        }
      }

      for (int treeIndex = parentIndex + 1;
          treeIndex < widget.filesTree.length;
          treeIndex++) {
        if (widget.filesTree[treeIndex].filePath.startsWith(filePath)) {
          widget.filesTree[treeIndex].checkValue = value;
        } else {
          break;
        }
      }
    }

    setState(() {});
  }

  void expand(String filePath) {
    List<String> paths = filePath.split('/');
    paths.removeWhere((element) => element.isEmpty ? true : false);

    Map<dynamic, dynamic> selectedChildrentFiles = widget.jsonTreeFormat;

    for (var index = 0; index < paths.length; index++) {
      selectedChildrentFiles = selectedChildrentFiles[paths[index]];
    }

    int treeIndex = 0;
    for (; treeIndex < widget.filesTree.length; treeIndex++) {
      if (widget.filesTree[treeIndex].filePath == filePath) {
        widget.filesTree[treeIndex].selecting = true;
        treeIndex++;
        break;
      }
    }

    for (final key in selectedChildrentFiles.keys) {
      widget.filesTree.insert(
          treeIndex,
          FileInfo(
              false,
              widget.filesTree[treeIndex - 1].tabs + 2,
              filePath + '/' + key,
              widget.filesTree[treeIndex - 1].checkValue));
    }

    setState(() {});
  }

  void collapse(String filePath) {
    int totalChild = 0;
    int parentIndex = 0;

    for (int treeIndex = 0; treeIndex < widget.filesTree.length; treeIndex++) {
      if (widget.filesTree[treeIndex].filePath == filePath) {
        parentIndex = treeIndex;
        break;
      }
    }

    for (int treeIndex = parentIndex + 1;
        treeIndex < widget.filesTree.length;
        treeIndex++) {
      if (widget.filesTree[treeIndex].filePath.startsWith(filePath)) {
        totalChild++;
      } else {
        break;
      }
    }

    for (int i = 0; i < totalChild; i++) {
      widget.filesTree.remove(widget.filesTree[parentIndex + 1]);
    }

    widget.filesTree[parentIndex].selecting = false;

    setState(() {});
  }

  void updateList(String filePath, bool selecting) {
    if (selecting) {
      collapse(filePath);
    } else {
      expand(filePath);
    }
  }
}
