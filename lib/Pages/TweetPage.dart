import 'package:FlitterApp/AddTweetsPage.dart';
import 'package:FlitterApp/CommentsPage.dart';
import 'package:FlitterApp/utilize/Variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TweetPage extends StatefulWidget {

  
  @override
  _TweetPageState createState() => _TweetPageState();
}


class _TweetPageState extends State<TweetPage> {

  String uid;

  initState(){

    super.initState();

    getCurrentUseruid();
  }

  getCurrentUseruid()async{

    var firebaseuser=FirebaseAuth.instance.currentUser;

    setState(() {
      
      uid=firebaseuser.uid;
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

      appBar: AppBar(

        actions: [

          Icon(Icons.star,size: 32,),
        ],
          
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text("Flitter App",
              style: MyStyle(20,Colors.white,FontWeight.w700),
              
              ),

              

            ],

          ),
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTweetsPage())),
        child: Icon(Icons.add,size: 32,)
        
        ),
      
      body: StreamBuilder(
        stream: tweetCollection.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          return ListView.builder(
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
    );
  }
}