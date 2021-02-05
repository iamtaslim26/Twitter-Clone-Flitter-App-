
import 'dart:io';
import 'package:FlitterApp/utilize/Variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTweetsPage extends StatefulWidget {
  @override
  _AddTweetsPageState createState() => _AddTweetsPageState();
}

class _AddTweetsPageState extends State<AddTweetsPage> {

  File imagePath;
  bool uploading=false;

  pickImage(ImageSource imgsource) async {
    final image = await ImagePicker().getImage(source: imgsource);
    setState(() {
      imagePath = File(image.path);
    });

    Navigator.pop(context);
  }

  TextEditingController TweetController = TextEditingController();

  uploadImage(String id)async{

    UploadTask uploadTask=pictureTweet.child(id).putFile(imagePath);

    TaskSnapshot snapshot=await uploadTask.whenComplete(() => null);

    String downloadUrl=await snapshot.ref.getDownloadURL();
    return downloadUrl;

//   //   uploadTask.then((res) {
//   //  res.ref.getDownloadURL();
// });


  }



  PostTweet() async {

    setState(() {
      uploading=true;
    });
    var firebaseuser = await FirebaseAuth.instance.currentUser;

    DocumentSnapshot userdoc = await usercollection.document(firebaseuser.uid).get();

        

    var allDocuments = await tweetCollection.getDocuments();
    int length = allDocuments.documents.length;

    if (TweetController.text != '' && imagePath == null) {

      // Only Tweet


    

      tweetCollection.document('Tweet $length').setData({


        'username':userdoc['username'],
        'profilepic':userdoc['profilepic'],
        'id':'Tweet $length',
        'uid':firebaseuser.uid,
        'likes':[],
        'commentsCount':0,
        'Tweets':TweetController.text,
        'shares':0,
        'type':1,


      });
      
      Navigator.pop(context);
    }

    
    else if (TweetController.text == '' && imagePath != null) {

      //Only Image
      String imageUrl=await uploadImage('Tweet $length');
      tweetCollection.document('Tweets $length').setData({

        'username':userdoc['username'],
        'profilepic':userdoc['profilepic'],
        'id':'Tweet $length',
        'uid':firebaseuser.uid,
        'likes':[],
        'commentsCount':0,
        'image':imageUrl,
        'shares':0,
        'type':2,


      });

      Navigator.pop(context);

    }
    else if (TweetController.text != '' && imagePath != null) {

         String imageUrl=await uploadImage('Tweet $length');
      tweetCollection.document('Tweets $length').setData({

        'username':userdoc['username'],
        'profilepic':userdoc['profilepic'],
        'id':'Tweet $length',
        'uid':firebaseuser.uid,
        'likes':[],
        'commentsCount':0,
        'image':imageUrl,
        'Tweets':TweetController.text,
        'shares':0,
        'type':3,


      });

      Navigator.pop(context);

    }
  }


  OpenDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(

            children: <Widget>[

              SimpleDialogOption(

                onPressed: () => pickImage(ImageSource.gallery),
                child: Text("Open From Gallery", style: MyStyle(20),),
              ),

              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.camera),
                child: Text("Open From Camera", style: MyStyle(20),),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel ", style: MyStyle(20),),
              )


            ],

          );
        }

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () => PostTweet(),
        child: Icon(Icons.send),

      ),

      appBar: AppBar(

        leading: InkWell(

          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 32,),

        ),

        actions: [

          InkWell(
            onTap: () => OpenDialog(),
            child: Icon(Icons.photo,
              size: 32,),
          )
        ],

        title: Text("Add Tweet",

          style: MyStyle(20),
        ),

        centerTitle: true,

      ),
      body: uploading==false?Column(

        children: <Widget>[

          Expanded(
            
              child: TextField(

      
               controller: TweetController,
                maxLines: null,
                style: MyStyle(20),
                decoration: InputDecoration(

                    hintText: "What's happening now",
                    hintStyle: MyStyle(25),
                    border: InputBorder.none
                ),

              )

          ),

          imagePath == null ? Container() : MediaQuery
              .of(context)
              .viewInsets
              .bottom > 0 ? Container() : Image
            (

            width: 200, height: 200,
            image: FileImage(imagePath),

          ),
        ],
      ): Center(
        child: Text("Uploading",style: MyStyle(20,Colors.black,FontWeight.w700),),
      )


      


    );
  }
}


