import 'package:drape_shoppe_crm/constants/app_constants.dart';
import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/models/task.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/screens/task/comments_screen.dart';
import 'package:drape_shoppe_crm/screens/task/widgets/custom_text_feild.dart';
import 'package:drape_shoppe_crm/screens/task/widgets/task_modal_widgets.dart';
import 'package:drape_shoppe_crm/screens/home/widgets/user_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import 'widgets/custom_task_icon_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.isNewTask, this.dealNo});
  final String? dealNo;
  final bool isNewTask;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController descController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController assignedtoController = TextEditingController();
  TextEditingController designerController = TextEditingController();

  FocusNode descFocusNode = FocusNode();
  FocusNode taskNameFocusNode = FocusNode();
  FocusNode assignedToFocusNode = FocusNode();
  FocusNode designerFocusNode = FocusNode();

  @override
  void dispose() {
    descController.dispose();
    titleController.dispose();
    assignedtoController.dispose();
    designerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (!widget.isNewTask) {
      HomeProvider.instance.setControllers(widget.dealNo!, titleController,
          descController, assignedtoController, designerController);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.exit_to_app_rounded),
        ),
        title: Text(widget.isNewTask ? 'Add Task' : 'Edit Task'),
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
                            provider.taskStatus[provider.selectedStatusIndex]
                                ["text"],
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
          child: Consumer<HomeProvider>(
            builder: (BuildContext context, provider, Widget? child) {
              return Column(
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: provider.selectedPriorityIndex,
                              hint: Row(
                                children: [
                                  CustomTaskIconWidget(
                                    color: provider.priorityValues[provider
                                        .selectedPriorityIndex]["color"],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    provider.priorityValues[
                                        provider.selectedPriorityIndex]["text"],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              icon: const Icon(Icons.arrow_drop_down_rounded),
                              iconSize: 18,
                              isExpanded: true,
                              onChanged: (int? newIndex) {
                                provider.setSelectedPriority(newIndex!);
                              },
                              items: List.generate(
                                  provider.priorityValues.length, (index) {
                                final item = provider.priorityValues[index];
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Row(
                                    children: [
                                      CustomTaskIconWidget(
                                        color: item['color'],
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        item['text'],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                        focusNode: assignedToFocusNode,
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
              );
            },
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: AppConstants.appPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                    dealNo: '',
                    isNewTask: true,
                  ),
                ),
              ),
              icon: Icon(Icons.comment_outlined),
            ),
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
                widget.isNewTask ? createTask() : editTask();
                context.goNamed('home');
                Fluttertoast.showToast(
                  msg: widget.isNewTask ? "Task Created!" : "Task Edited!",
                );
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
                widget.isNewTask ? 'Create Task' : 'Edit Task',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createTask() {
    FirebaseController.instance.setTask(
      HomeProvider.instance.selectedPriority,
      titleController.text,
      descController.text,
      designerController.text,
      100,
      HomeProvider.instance.selectedStatus,
      ['test'],
      HomeProvider.instance.pickedFile,
    );
  }

  void editTask() {
    FirebaseController.instance.editTask(
      widget.dealNo!,
      HomeProvider.instance.selectedPriority,
      titleController.text,
      descController.text,
      designerController.text,
      100,
      HomeProvider.instance.selectedStatus,
      ['test'],
      HomeProvider.instance.pickedFile,
    );
  }
}
