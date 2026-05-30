import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';
import 'package:taskmanager/ui/widgets/taskcard.dart';
import 'package:taskmanager/ui/widgets/tmappbar.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  List<TaskModel> _cancelledTaskList = [];
  bool _getTaskcancelled = false;

  //dynamic progress task
  Future<void> _cancelledTaskDynamic() async {
    _getTaskcancelled = true;
    setState(() {});

    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.cancelledTaskUrl,
    );
    //response peye geche ekhon ar ghurar dorkar nai count er
    _getTaskcancelled = false;
    setState(() {});

    List<TaskModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }

    _cancelledTaskList = list; // use externally
  }

  @override
  void initState() {
    _cancelledTaskDynamic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Visibility(
          visible: _getTaskcancelled == false,
          replacement: Center(
                child: CircularProgressIndicator(),
              ),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return TaskCard(
                cardColor: Colors.blue,
                taskmodel: _cancelledTaskList[index],
                refreshParent: () {
                  _cancelledTaskDynamic();
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            },
            itemCount: _cancelledTaskList.length,
          ),
        ),
      ),
    );
  }
}
