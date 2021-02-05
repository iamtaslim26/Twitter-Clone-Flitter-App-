import 'package:FlitterApp/utilize/Variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:FlitterApp/CommentsPage.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  
  String uid;
  Stream userstream;
  bool dataisThere=false;
   bool isfollowing;
  int following,followers;

  String username="";
  String profilepic="";

  initState(){

    super.initState();

    getCurrentUseruid();
    getStream();
    getCurrentUserInfo();
  }

  getStream()async{

    var firebaseuser=FirebaseAuth.instance.currentUser;

    setState(() {

     userstream =
          tweetCollection.where('uid', isEqualTo: firebaseuser.uid).snapshots();
    });
  }

  getCurrentUseruid()async{

    var firebaseuser=FirebaseAuth.instance.currentUser;

    setState(() {
      
      uid=firebaseuser.uid;
    });
    
  }

  getCurrentUserInfo()async{

    // path to get data from firestore

    var firebaseuser=FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc=await usercollection.doc(firebaseuser.uid).get();
    dataisThere=true;

     var followersdocuments=await usercollection.doc(firebaseuser.uid)
                          .collection("Followers")
                          .get();

    var followingdocuments=await usercollection.doc(firebaseuser.uid)
                          .collection("Followers")
                          .get();  

     usercollection.doc(firebaseuser.uid)
     .collection("Followers")
     .doc(firebaseuser.uid)
     .get()
     .then((documents){
       
       if(documents.exists){

         setState(() {
           
           isfollowing=true;
         });
       }
       else{

         setState(() {
           
           isfollowing=false;
         });
       }

     });

    setState(() {
      username=userdoc['username'];
      profilepic=userdoc['profilepic'];
      followers=followersdocuments.docs.length;
      following=followingdocuments.docs.length;
    });

                                       

    setState(() {
      username=userdoc['username'];
      profilepic=userdoc['profilepic'];
      
       following = followingdocuments.docs.length;
      followers = followersdocuments.docs.length;
    });

  }

  sharePost(String id,String tweet)async{

    Share.text('Flitter', tweet, 'text/plain');

    DocumentSnapshot documents=await tweetCollection.document(id).get();

    tweetCollection.document(id).updateData({

      'shares':documents['shares']+1

    });
  }

   

  
  

    
  likePost(String id)async{

      
    
      var firebaseuser=await FirebaseAuth.instance.currentUser;

      DocumentSnapshot documentSnapshot=await tweetCollection.doc(id).get();

      if (documentSnapshot['likes'].contains(firebaseuser.uid)) {

      // already like case

      tweetCollection.doc(id).update({

        'likes':FieldValue.arrayRemove([firebaseuser.uid])
      });

        
      }
      else{

          tweetCollection.doc(id).update({

            'likes':FieldValue.arrayUnion([firebaseuser.uid]),
            

          });
      }
  




  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: dataisThere==true ?SingleChildScrollView(

          physics: ScrollPhysics(),
          child: Stack(

            children:<Widget> [

              Container(

                height: MediaQuery.of(context).size.height/4,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(

                  gradient: LinearGradient(
                    colors:[ Colors.lightBlue,Colors.purple],
                  )
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/6,
                  left: MediaQuery.of(context).size.width/2-64
                  
                  ),

                child: CircleAvatar(

                  
                  radius: 64,
                  backgroundColor: Colors.white,
                  backgroundImage:NetworkImage(profilepic),
                  
                ),
              ),

              Container(

              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/2.7),
              alignment: Alignment.center,
              child: Column(

                children: <Widget>[
                  
                  
                  Text(username,style: MyStyle(30,Colors.black,FontWeight.w600),),

                  SizedBox(height: 17,),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Text("Following ",style: MyStyle(20,Colors.black,FontWeight.w600),),
                      Text("Followers ",style: MyStyle(20,Colors.black,FontWeight.w600),),
                    ],
                  ),

                  SizedBox(height: 15,),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Text(following.toString(),style: MyStyle(20,Colors.black,FontWeight.w600),),
                      Text(followers.toString(),style: MyStyle(20,Colors.black,FontWeight.w600),),
                    ],
                  ),

                  SizedBox(height: 15,),

                  InkWell(

                    onTap: (){},

                    child: Container(

                      width: MediaQuery.of(context).size.width/2,
                      height: 50,
                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(colors:[Colors.lightBlue,Colors.blue]),
                        
                      ),
                      child: Center(
                        child: Text("Edit Profile",style: MyStyle(25,Colors.white,FontWeight.w700),)
                        ),

                      
                    ),
                  ),

              SizedBox(height: 15,),
              Center(child: Text("User Tweets",style: MyStyle(25,Colors.black,FontWeight.w600),)),

              StreamBuilder(
        stream: userstream,


        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context,int index){

              DocumentSnapshot tweetdoc=snapshot.data.documents[index];


                return Card(

                  child: ListTile(
                    
                    leading: CircleAvatar(


                  backgroundColor:Colors.white ,
                  backgroundImage: NetworkImage(tweetdoc['profilepic']),        

                  
                   ),

                   title: Text(tweetdoc['username'],
                   
                   style: MyStyle(20,Colors.black,FontWeight.w600),
                   ),

                   subtitle: 
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                         children:<Widget> [
                            
                          if(tweetdoc['type']==1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(tweetdoc['Tweets'],style: MyStyle(20,Colors.black,FontWeight.w700),),
                          ),

                         
                          SizedBox(height: 10,),

                           if(tweetdoc['type']==2)
                          Column(
                              children: <Widget >[

                                Image( image: NetworkImage(tweetdoc['image'])),

                         
                              ],
                           ),
                          

                           if(tweetdoc['type']==3)
                           Column(
                              children: <Widget >[

                                Image( image: NetworkImage(tweetdoc['image'])),
                          Text(tweetdoc['Tweets'],style: MyStyle(20,Colors.black,FontWeight.w700),),
                              ],
                           ),
                        

                            Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: <Widget>[

                                InkWell(
                                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentsPage(tweetdoc['id']))),
                                  child: Row(
                                    children: [
                                      Icon(Icons.comment),
                                       SizedBox(width: 10,),
                                  Text(tweetdoc['commentsCount'].toString(),style: MyStyle(18),),
                                    ],
                                  ),
                                ),
                               


                                Row(
                                  children: [
                                    InkWell(

                                    onTap: ()=>likePost(tweetdoc['id']),  
                                    child: tweetdoc['likes'].contains(uid)?
                                    
                                     Icon(
                                       Icons.favorite,
                                       color: Colors.red,
                                       ):
                                    
                                    Icon(Icons.favorite_border)),
                                     SizedBox(width: 10,),
                                Text(tweetdoc['likes'].length.toString(),style: MyStyle(18),),
                                  ],
                                ),



                                Row(
                                  children: [
                                    InkWell(
                                      onTap: ()=>sharePost(tweetdoc['id'],tweetdoc['Tweets']),
                                      child: Icon(Icons.share)
                                      
                                      ),

                                     SizedBox(width: 10,),
                                Text(tweetdoc['shares'].toString(),style: MyStyle(18),),
                                  ],
                                ),
                              ],
                            )


                            
                  


                         ],
                     ),
                      ),
                   
                  ),
                );


            }
            
            );
        }
      ),

                  
                ],
              ),
              ),
             

            

              
            ],
          ),
        ):Center(child: CircularProgressIndicator(),)
    );
  }
}


