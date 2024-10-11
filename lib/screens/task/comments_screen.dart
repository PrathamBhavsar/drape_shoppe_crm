import 'package:drape_shoppe_crm/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  // Define priority values with text and color

  TextEditingController commentController = TextEditingController();

  FocusNode commentFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Text(snapshot.data.toString());
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: AppConstants.appPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                focusNode: commentFocusNode,
                decoration: InputDecoration(
                  filled: true,
                  // fillColor: Colors.green,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'Type a Message',
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () {
                  print(commentController.text);
                },
                icon: Icon(Icons.send_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
