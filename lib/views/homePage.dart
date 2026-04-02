import 'package:flutter/material.dart';
import 'package:task_thingy/utils/layoutMath.dart';
import 'package:task_thingy/views/addTaskMenu.dart';
import 'package:task_thingy/views/timeline.dart';
import 'package:flutter/widget_previews.dart';
import 'package:task_thingy/utils/theme.dart';
import 'package:task_thingy/views/topAppBar.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      backgroundColor: homePageColors.background.color,
      appBar: topAppBar(context: context),
      body: Padding(
        padding: conversionFactors.bubbleWidthFactor.getHomePagePadding(
          TimeLineLayout.getScreenHeight(context),
          TimeLineLayout.getScreenWidth(context),
        ),
        child: Timeline(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTaskMenu(),
          );
        },
        backgroundColor: colors.buttonColor.color,
        child: Icon(Icons.add_rounded, color: colors.taskTextColor.color),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

@Preview(name: "Home")
Widget HomePreview() {
  return MyHomePage();
}
