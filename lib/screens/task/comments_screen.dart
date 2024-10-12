import 'package:drape_shoppe_crm/constants/app_constants.dart';
import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/models/comment.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen(
      {super.key, required this.dealNo, required this.isNewTask});

  final String dealNo;
  final bool isNewTask;

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
                widget.isNewTask
                    ? Text('add data')
                    : Container(
                        height: 400,
                        child: FutureBuilder<List<CommentModel>>(
                            future: FirebaseController.instance
                                .fetchComments('20241009144217'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }
                              List<CommentModel> comments = snapshot.data!;

                              return CustomCommentListView(
                                comments: comments,
                              );
                            }),
                      ),
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: const UnderlineInputBorder(
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
                  print(widget.dealNo);
                  HomeProvider.instance.setComment(commentController.text);
                  //clear controller text
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

class CustomCommentListView extends StatelessWidget {
  const CustomCommentListView({super.key, required this.comments});

  final List<CommentModel> comments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        CommentModel comment = comments[index];
        return Text('${comment.user} : ${comment.comment}');
      },
    );
  }
}
