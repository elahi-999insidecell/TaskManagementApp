import 'dart:core';

import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskmodel,
    required this.cardColor,
    required this.refreshParent,
  });

  final TaskModel taskmodel;
  final Color cardColor;
  final VoidCallback refreshParent;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _deleteLoading = false;
  bool _changeStatusInProgress = false;
  Future<void> _changeStatus(String status) async {
    _changeStatusInProgress = true;

    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.changeStatus(widget.taskmodel.id, status),
    );
    //response peye geche ekhon ar ghurar dorkar nai
    _changeStatusInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      widget.refreshParent();
      Navigator.pop(context);
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }

  //delete Task
  Future<void> deleteYoYo() async {
    _deleteLoading = true;

    //api call
    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskmodel.id),
    );

    _deleteLoading = false;
    setState(() {});

    if (response.isSuccess) {
      widget.refreshParent();
      showSnackBarMessage(context, "Task deleted successfully");
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //changing status
    void showChangeStatusDialogue() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Change Status"),
            content: Column(
              mainAxisSize: MainAxisSize.min, // making the column cuter

              children: [
                ListTile(
                  onTap: () {
                    _changeStatus('New');
                  },
                  title: Text("New"),
                  trailing: widget.taskmodel.status == "New"
                      ? Icon(Icons.done)
                      : null,
                  //show the current status here
                ),
                ListTile(
                  onTap: () {
                    _changeStatus('Progress');
                  },
                  title: Text("Progress"),
                  trailing: widget.taskmodel.status == "Progress"
                      ? Icon(Icons.done)
                      : null,
                  //show the current status here
                ),
                ListTile(
                  onTap: () {
                    _changeStatus('Cancelled');
                  },
                  title: Text("Cancelled"),
                  trailing: widget.taskmodel.status == "Cancelled"
                      ? Icon(Icons.done)
                      : null,
                  //show the current status here
                ),
                ListTile(
                  onTap: () {
                    _changeStatus('Completed');
                  },
                  title: Text("Completed"),
                  trailing: widget.taskmodel.status == "Completed"
                      ? Icon(Icons.done)
                      : null,
                  //show the current status here
                ),
              ],
            ),
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            widget.taskmodel.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.taskmodel.description),
              SizedBox(height: 10),
              Text(widget.taskmodel.createdDate),
              SizedBox(height: 10),
              Row(
                children: [
                  Chip(
                    label: Text(widget.taskmodel.status),
                    backgroundColor: widget.cardColor,
                    labelStyle: TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  ),

                  Spacer(),

                  IconButton(
                    onPressed: () {
                      showChangeStatusDialogue();
                    },
                    style: IconButton.styleFrom(foregroundColor: Colors.green),
                    icon: Icon(Icons.edit_note_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteYoYo();
                    },
                    style: IconButton.styleFrom(foregroundColor: Colors.red),
                    icon: Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
