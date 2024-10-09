import 'package:drape_shoppe_crm/constants/app_constants.dart';
import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/router/routes.dart';
import 'package:drape_shoppe_crm/screens/task/widgets/task_modal_widgets.dart';
import 'package:drape_shoppe_crm/screens/home/widgets/user_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_task_icon_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Define priority values with text and color
  List<Map<String, dynamic>> priorityValues = [
    {'text': 'Low', 'color': const Color.fromARGB(255, 182, 255, 220)},
    {'text': 'Medium', 'color': const Color.fromARGB(255, 254, 254, 226)},
    {'text': 'High', 'color': const Color.fromARGB(255, 255, 160, 160)},
  ];

  String? selectedPriority;
  TextEditingController descController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController assignedtoController = TextEditingController();
  TextEditingController designerController = TextEditingController();

  FocusNode descFocusNode = FocusNode();
  FocusNode taskNameFocusNode = FocusNode();
  FocusNode assignedtoFocusNode = FocusNode();
  FocusNode designerFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.exit_to_app_rounded),
        ),
        title: const Text('Add Task'),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                showDragHandle: true,
                elevation: 1.5,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return TaskStatusModalWidget();
                },
              );
            },
            child: Consumer<HomeProvider>(
              builder: (BuildContext context, provider, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: provider.taskStatus[provider.selectedStatusIndex]
                            ["secondaryColor"]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CustomTaskIconWidget(
                            color: provider
                                    .taskStatus[provider.selectedStatusIndex]
                                ["primaryColor"],
                          ),
                          SizedBox(width: 10),
                          Text(
                            provider.selectedStatus,
                            style: TextStyle(
                                color: provider.taskStatus[provider
                                    .selectedStatusIndex]["primaryColor"],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 100,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPriority,
                          hint: Row(
                            children: [
                              CustomTaskIconWidget(
                                  color: priorityValues.firstWhere((item) =>
                                      item['text'] ==
                                      (selectedPriority == null
                                          ? 'Low'
                                          : selectedPriority))['color']),
                              const SizedBox(width: 10),
                              Text(
                                priorityValues.firstWhere((item) =>
                                    item['text'] ==
                                    (selectedPriority == null
                                        ? 'Low'
                                        : selectedPriority))['text'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          iconSize: 18,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPriority = newValue;
                            });
                          },
                          items: priorityValues.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> item) {
                              return DropdownMenuItem<String>(
                                value: item['text'],
                                child: Row(
                                  children: [
                                    CustomTaskIconWidget(
                                      color: item['color'],
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Spacing between icon and text
                                    Text(
                                      item['text'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Spacing between dropdown and text field
                    Expanded(
                      child: CustomTextFeild(
                        controller: titleController,
                        focusNode: taskNameFocusNode,
                        hint: 'Task Name',
                      ),
                    ),
                  ],
                ),
              ),
              CustomTextFeild(
                controller: descController,
                focusNode: descFocusNode,
                hint: 'Description',
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    showDragHandle: true,
                    elevation: 1.5,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return UserModalWidget();
                    },
                  );
                },
                child: Container(
                  child: CustomTextFeild(
                    controller: assignedtoController,
                    focusNode: assignedtoFocusNode,
                    hint: 'Assigned to',
                  ),
                ),
              ),
              CustomTextFeild(
                controller: designerController,
                focusNode: designerFocusNode,
                hint: 'Designer',
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: AppConstants.appPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  elevation: 1.5,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return AttachmentsModelWidget();
                  },
                );
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
                padding: WidgetStateProperty.all(AppConstants.appPadding),
              ),
              child: Text(
                'Add attachments',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // FirebaseController.instance.setTask(
                //   selectedPriority!,
                //   titleController.text,
                //   descController.text,
                //   designerController.text,
                //   100,
                //   HomeProvider.instance.selectedStatus,
                //   {'test': 'no'},
                //   ['test'],
                //   HomeProvider.instance.pickedFile,
                // );
                context.goNamed('home');
                // Fluttertoast.showToast(
                //   msg: "Uploaded!",
                // );
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                padding: WidgetStateProperty.all(AppConstants.appPadding),
              ),
              child: Text(
                'Create Task',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.readOnly,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        readOnly: readOnly ?? false,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          hintText: hint,
        ),
      ),
    );
  }
}
