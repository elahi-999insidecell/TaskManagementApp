import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';
import 'package:taskmanager/ui/widgets/taskcard.dart';
import 'package:taskmanager/ui/widgets/tmappbar.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  List<TaskModel> _progressTaskList = [];
  bool _getTaskProgress = false;

  //dynamic progress task
  Future<void> _progressTaskDynamic() async {
    _getTaskProgress = true;
    setState(() {});

    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.progressTaskUrl,
    );
    //response peye geche ekhon ar ghurar dorkar nai count er
    _getTaskProgress = false;
    setState(() {});

    List<TaskModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }

    _progressTaskList = list; // use externally
  }

  @override
  void initState() {
    _progressTaskDynamic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Visibility(
          visible: _getTaskProgress == false ,
          replacement: Center(child: CircularProgressIndicator()) ,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return TaskCard(
                cardColor: Colors.blue,
                taskmodel: _progressTaskList[index],
                refreshParent: () {
                  _progressTaskDynamic();
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            },
            itemCount: _progressTaskList.length,
          ),
        ),
      ),
    );
  }
}
