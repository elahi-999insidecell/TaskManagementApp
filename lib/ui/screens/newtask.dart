import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/models/task_status_count_model.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/screens/add_new_task.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';
import 'package:taskmanager/ui/widgets/taskcard.dart';
import 'package:taskmanager/ui/widgets/taskcountbystatus.dart';
import 'package:taskmanager/ui/widgets/tmappbar.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  bool _getTaskStatusCountProgress = false;
  final bool _getTaskProgress = false;
  List<TaskStatusCountModel> _taskStatuscountList = [];
  //ei list e add korbo how many count

  List<TaskModel> _newTaskList = []; // dynamic new added tasks

  //apicall
  Future<void> _getAllTaskCount() async {
    _getTaskStatusCountProgress = true;
    setState(() {});

    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.taskCountUrl,
    );
    //response peye geche ekhon ar ghurar dorkar nai count er
    _getTaskStatusCountProgress = false;
    setState(() {});

    List<TaskStatusCountModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }

    _taskStatuscountList = list; // use externally
  }

  //dynamic new task
  Future<void> _newTaskdynamic() async {
    _getTaskStatusCountProgress = true;
    setState(() {});

    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.newTaskUrl,
    );
    //response peye geche ekhon ar ghurar dorkar nai count er
    _getTaskStatusCountProgress = false;
    setState(() {});

    List<TaskModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }

    _newTaskList = list; // use externally
  }

  //init state e call korle ui update hhbe
  @override
  void initState() {
    super.initState();
    _getAllTaskCount();
    _newTaskdynamic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Column(
        children: [
          SizedBox(height: 15),
          SizedBox(
            height: 90,

            child: Visibility(
              visible: _getTaskStatusCountProgress== false,
              replacement: Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _taskStatuscountList.length,
                itemBuilder: (context, index) {
                  return TaskCountByStatus(
                    title: _taskStatuscountList[index].status,
                    count: _taskStatuscountList[index].count,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 4);
                },
              ),
            ),
          ),
          SizedBox(height: 20),

          Expanded(
            child: Visibility(
              visible: _getTaskStatusCountProgress == false,
              replacement: Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return TaskCard(
                    cardColor: Colors.blue,
                    taskmodel: _newTaskList[index],
                    refreshParent: () {
                      _newTaskdynamic();
                      _getAllTaskCount();
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 4);
                },
                itemCount: _newTaskList.length,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewTask()),
          );
          _newTaskdynamic();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
