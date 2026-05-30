// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/utils/screen_background.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';
import 'package:taskmanager/ui/widgets/tmappbar.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  //formkey nicchi
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  //main screen shuru
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  SizedBox(height: 24),
                  TextFormField(
                    controller: titleController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Title or Subject of your task";
                      }

                      return null;
                    },
                    decoration: InputDecoration(hintText: "Subject"),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: desController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Description";
                      }

                      return null;
                    },
                    minLines: 10,
                    maxLines: 30,
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                  SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addNeewTask();
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _addTaskProg = false; // checking if any progress or loading

  Future<void> addNeewTask() async {
    _addTaskProg = true;
    setState(() {});

    Map<String, dynamic> requestBodyofAddNiuTask = {
      "title": titleController.text,
      "description": desController.text,
      "status": "New",
    }; //from backend response postman theke dekhe request body er format ta copy kore nilam

    final ApiResponse response = await Apicaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBodyofAddNiuTask,
    );
    _addTaskProg = false; //
    setState(() {});
    if (response.isSuccess) {
      _clearTextField();
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/navbar",
        (predicate) => false,
      );
      showSnackBarMessage(context, "New Task Added Successfully");
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  _clearTextField() {
    titleController.clear();
    desController.clear();
  }
}
