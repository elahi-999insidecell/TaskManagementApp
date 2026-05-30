import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';
import 'package:taskmanager/ui/widgets/taskcard.dart';
import 'package:taskmanager/ui/widgets/tmappbar.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<TaskModel> _completedTaskList = [];
  bool _getTaskcompleted = false;

  //dynamic progress task
  Future<void> _completedTaskDynamic() async {
    _getTaskcompleted = true;
    setState(() {});

    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.completedTaskUrl,
    );
    //response peye geche ekhon ar ghurar dorkar nai count er
    _getTaskcompleted = false;
    setState(() {});

    List<TaskModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }

    _completedTaskList = list; // use externally
  }

  @override
  void initState() {
    _completedTaskDynamic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Visibility(
          visible: _getTaskcompleted == false ,
          replacement: Center(
                child: CircularProgressIndicator(),
              ),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return TaskCard(
                cardColor: Colors.blue,
                taskmodel: _completedTaskList[index],
                refreshParent: () {
                 _completedTaskDynamic();
                 
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            },
            itemCount: _completedTaskList.length,
          ),
        ),
      ),
    );
  }
}
