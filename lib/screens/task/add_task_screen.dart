import 'package:drape_shoppe_crm/constants/app_constants.dart';
import 'package:drape_shoppe_crm/screens/home/widgets/task_modal_widgets.dart';
import 'package:drape_shoppe_crm/screens/home/widgets/user_modal_widget.dart';
import 'package:flutter/material.dart';

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

  String? selectedValue;
  TextEditingController descController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController assignedtoController = TextEditingController();

  FocusNode descFocusNode = FocusNode();
  FocusNode taskNameFocusNode = FocusNode();
  FocusNode assignedtoFocusNode = FocusNode();

  void doSomething() {
    assignedtoFocusNode.addListener(() {
      if (assignedtoFocusNode.hasFocus) {
        _buildUserModelSheet();
        print('object');
      }
    });
  }

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
            child: Text(
              'pending',
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Container(
                // color: Colors.red,
                height: 50, // Height of the outer container
                child: Row(
                  children: [
                    Container(
                      height: 40, // Set the same height as the outer container
                      width: 100, // Adjust width if needed
                      child: DropdownButtonHideUnderline(
                        // Hide the default underline of the DropdownButton
                        child: DropdownButton<String>(
                          value: selectedValue,
                          hint: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: priorityValues.firstWhere((item) =>
                                        item['text'] ==
                                        (selectedValue == null
                                            ? 'Low'
                                            : selectedValue))['color']),
                                height: 9,
                                width: 9,
                              ),
                              const SizedBox(
                                  width: 8), // Spacing between icon and text
                              Text(
                                priorityValues.firstWhere((item) =>
                                    item['text'] ==
                                    (selectedValue == null
                                        ? 'Low'
                                        : selectedValue))['text'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          iconSize: 18,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue;
                            });
                          },
                          items: priorityValues.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> item) {
                              return DropdownMenuItem<String>(
                                value: item['text'],
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: item['color'],
                                      ),
                                      height: 9,
                                      width: 9,
                                    ),
                                    const SizedBox(
                                        width:
                                            8), // Spacing between icon and text
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
                        controller: taskNameController,
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
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
            ],
          ),
        ),
      ),
    );
  }

  _buildAttachmentModalSheet() {
    return showModalBottomSheet(
      showDragHandle: true,
      elevation: 1.5,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UserModalWidget();
      },
    );
  }

  _buildUserModelSheet() {
    return showModalBottomSheet(
      showDragHandle: true,
      elevation: 1.5,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UserModalWidget();
      },
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
    return TextField(
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
    );
  }
}
