import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_fixed/utils/colors.dart';
import 'package:instagram_clone_fixed/utils/snackbar.dart';
import 'package:instagram_clone_fixed/widgets/profile_buttons.dart';


class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['followings'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Column buildStatColumn(String title, int count) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Text(
                userData['username'],
                style: const TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.messenger_outline,
                      color: blackColor,
                    ))
              ],
            ),
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16).copyWith(top: 0),
                    child: Row(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(10).copyWith(top: 20),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userData['photoURL']),
                            radius: 40,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Padding(padding: EdgeInsets.only(left: 25)),
                                  buildStatColumn('Posts', postLen),
                                  buildStatColumn('followers', followers),
                                  buildStatColumn('following', following),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            widget.uid
                                        ? const FollowButton(
                                            backgroundColor: Colors.transparent,
                                            borderColor: Colors.black,
                                            text: 'Edit Profile',
                                            textColor: Colors.black)
                                        : isFollowing
                                            ? const FollowButton(
                                                backgroundColor:
                                                    Colors.transparent,
                                                borderColor: Colors.black,
                                                text: 'unfollow',
                                                textColor: Colors.black)
                                            : const FollowButton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.black,
                                                text: 'follow',
                                                textColor: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //full name
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      userData['fullName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  //bio
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
                    alignment: Alignment.bottomLeft,
                    child: const Text('bio goes here'),
                  ),

                  Divider(
                    color: Colors.grey.shade400,
                  ),

                  //posts or reels

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          onPressed: () {},
                          icon: Icon(
                            Icons.video_label_outlined,
                            size: 30,
                            color: Colors.grey.shade600,
                          )),
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          onPressed: () {},
                          icon: Icon(Icons.video_library_outlined,
                              size: 30, color: Colors.grey.shade600)),
                    ],
                  ),

                  //posts grid

                  Expanded(
                    //  child: FutureBuilder(
                    //                future: FirebaseFirestore.instance.collection('posts').get(),
                    //                builder: (context, snapshot) {
                    //                  if (!snapshot.hasData) {
                    //                    const Center(
                    //                      child: CircularProgressIndicator(),
                    //                    );
                    //                  }

                    //                  return MasonryGridView.builder(
                    //                      crossAxisSpacing: 4,
                    //                      mainAxisSpacing: 4,
                    //                      gridDelegate:
                    //   const  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2),
                    //                      itemCount: (snapshot.data! as dynamic).docs.length,
                    //                      itemBuilder: (context, index) {
                    //   return ClipRRect(
                    //     child: Image.network((snapshot.data! as dynamic)
                    //         .docs[index]['postURL']),
                    //   );
                    //                      });
                    //                }
                    //                ),

                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3
                                      ),
                              itemBuilder: (context, index) {
                                return Container(
                                    child: Image(
                                        image: NetworkImage(
                                            (snapshot.data! as dynamic)
                                                .docs[index]['postURL']),

                                                fit: BoxFit.cover,

                                                )
                                                );
                              });
                        }),
                  )
                ],
              ),
            ),
          );
  }
}
