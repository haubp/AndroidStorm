import 'package:flutter/material.dart';
import 'fileExplorer.dart';
import 'file.dart';

import 'dart:io';

void main() => runApp(MyApp());

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
  final Map<String, Map> jsonTreeFormat = {
    'mnt': {},
    'etc': {},
    'usr': {'bin': {}, 'lib': {}},
    'home': {'Downloads': {}, 'Document': {}},
  };

  final List<FileInfo> filesTree = <FileInfo>[];

  MyHomePage({Key key}) : super(key: key) {
    for (final entry in jsonTreeFormat.keys) {
      filesTree.add(FileInfo(false, 0, entry));
    }
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: FileExplorer(widget.filesTree, updateList)),
    );
  }

  void updateList(String filePath, bool) {
    stderr.writeln(filePath);

    List<String> paths = filePath.split('/');
    paths.removeWhere((element) => element.isEmpty ? true : false);

    Map<dynamic, dynamic> selectedChildrentFiles = widget.jsonTreeFormat;

    for (var index = 0; index < paths.length; index++) {
      selectedChildrentFiles = selectedChildrentFiles[paths[index]];
    }

    int treeIndex = 0;
    for (; treeIndex < widget.filesTree.length; treeIndex++) {
      if (widget.filesTree[treeIndex].filePath == filePath) {
        treeIndex++;
        break;
      }
    }

    for (final key in selectedChildrentFiles.keys) {
      widget.filesTree.insert(treeIndex, FileInfo(true, 2, key));
    }

    setState(() {});
  }
}
