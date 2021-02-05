import 'package:FlitterApp/utilize/Variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart'as timeAgo;

class CommentsPage extends StatefulWidget {

   final String documentid;
  CommentsPage(this.documentid);
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {

  var CommentsController=TextEditingController();

  addComments()async{
 var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get();
    tweetCollection.doc(widget.documentid).collection('comments').doc().set({
      'comment': CommentsController.text,
      'username': userdoc.data()['username'],
      'uid': userdoc.data()['uid'],
      'profilepic': userdoc.data()['profilepic'],
      'time': DateTime.now()
    });

    CommentsController.clear();

    DocumentSnapshot commentcount=await tweetCollection.doc(widget.documentid).get();
    tweetCollection.doc(widget.documentid).update({

      'commentsCount':commentcount["commentsCount"]+1});
    
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                      stream: tweetCollection
                          .doc(widget.documentid)
                          .collection('comments')
                          .snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,

                            
                            itemBuilder: (context,  index) {

                              DocumentSnapshot commentdoc=snapshot.data.docs[index];

                              return ListTile(

                                leading: CircleAvatar(
                        
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(commentdoc.data()['profilepic']),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  commentdoc['username'],
                                  style: MyStyle(20),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  commentdoc['comment'],
                                  style:
                                      MyStyle(20, Colors.grey, FontWeight.w500),
                                ),
                              ],
                            ),

                            subtitle: Text(
                              
                              timeAgo.format(commentdoc['time'].toDate()).toString(),
                            ),
                              
                        );
                        });
                      }),
                ),
                Divider(),
                ListTile(
                  title: TextFormField(
                    controller: CommentsController,
                    decoration: InputDecoration(
                      labelText: 'Comment..',
                      labelStyle: MyStyle(20, Colors.black, FontWeight.w700),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                  trailing: OutlineButton(
                    onPressed: () => addComments(),
                    borderSide: BorderSide.none,
                    child: Text(
                      "Publish",
                      style: MyStyle(16),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
    
  }
}