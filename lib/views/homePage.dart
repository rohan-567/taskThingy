import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/views/addTaskMenu.dart';
import 'package:task_thingy/views/timeline.dart';
import 'package:flutter/widget_previews.dart';

var counter = Signal<int>(0);

//screen height 911 width: 411

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      backgroundColor: const Color.fromARGB(255, 37, 36, 36),
      appBar: AppBar(
        title: Text("TaskThingy"),
        backgroundColor: const Color.fromARGB(202, 68, 137, 255),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.directional(
          top: 40,
          bottom: 120,
          start: 30,
          end: 30,
        ),
        child: Timeline(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTaskMenu(),
          );
        },
        backgroundColor: const Color.fromARGB(207, 143, 77, 103),
        child: Icon(
          Icons.add_rounded,
          color: const Color.fromARGB(255, 215, 213, 214),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

@Preview(name: "Home")
Widget HomePreview() {
  return MyHomePage();
}
