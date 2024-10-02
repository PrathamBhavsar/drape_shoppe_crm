import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Define priority values with text and color
  List<Map<String, dynamic>> priorityValues = [
    {'text': 'Low', 'color': Colors.greenAccent},
    {'text': 'Medium', 'color': Colors.yellowAccent},
    {'text': 'High', 'color': Colors.redAccent},
  ];

  String? selectedValue;
  TextEditingController descController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();

  FocusNode descFocusNode = FocusNode();
  FocusNode taskNameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app_rounded),
          ),
          title: const Text('Add Task'),
          centerTitle: false,
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
                        height:
                            40, // Set the same height as the outer container
                        width: 100, // Adjust width if needed
                        child: DropdownButtonHideUnderline(
                          // Hide the default underline of the DropdownButton
                          child: DropdownButton<String>(
                            value: selectedValue,
                            hint: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedValue == null
                                    ? Colors.grey
                                    : priorityValues.firstWhere((item) =>
                                        item['text'] == selectedValue)['color'],
                              ),
                              height: 9,
                              width: 9,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.hint});

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          hintText: hint),
    );
  }
}
