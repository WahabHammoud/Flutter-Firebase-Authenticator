import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_fixed/model/user.dart';
import 'package:instagram_clone_fixed/provider/user_provider.dart';
import 'package:instagram_clone_fixed/resources/firestore_method.dart';
import 'package:instagram_clone_fixed/utils/colors.dart';
import 'package:instagram_clone_fixed/utils/snackbar.dart';
import 'package:instagram_clone_fixed/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Comments',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('date',descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentsCard(snap: snapshot.data!.docs[index].data(),),
          );
        },
      ),
      bottomSheet: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
            .copyWith(bottom: 30),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.photoURL),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    // enabledBorder: OutlineInputBorder(
                    // borderSide: BorderSide(
                    // width: 1, color: Colors.grey
                    // )
                    // ),
                    hintText: 'comment as ${user.username}',
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  print('post pressed');
                  String res = await FireStoreMethods().postComment(
                      widget.snap['postId'],
                      commentController.text,
                      user.uid,
                      user.username,
                      user.photoURL);
                  showSnackBar(res, context);

                  setState(() {
                    commentController.text = '';
                  });
                },
                icon: const Icon(CupertinoIcons.paperplane))
          ],
        ),
      )),
    );
  }
}
