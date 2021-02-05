import 'package:FlitterApp/Pages/ViewUser.dart';
import 'package:FlitterApp/utilize/Variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  Future<QuerySnapshot>SearchUserResult;

  SearchUser(String string){

    

    var users=usercollection.where('username',isGreaterThanOrEqualTo: string).getDocuments();

    

    

    setState(() {
      SearchUserResult=users;
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[50],

   appBar: AppBar(

     title: TextFormField(

       decoration: InputDecoration(

         filled: true,
         hintText: "Search Users ",
         hintStyle: MyStyle(20),
    
       ),

       onFieldSubmitted: SearchUser,

       
     ),
   ),

   body:SearchUserResult==null?Center(

     child: Text("Search for Users"),
   ) :FutureBuilder(
     future: SearchUserResult,
     builder: (BuildContext context,Snapshots){

       if(Snapshots.hasData!=null){

         Center(
           child: CircularProgressIndicator(),
         
         );
         return ListView.builder(

           itemCount: Snapshots.data.docs.length,
           itemBuilder: (BuildContext context,int index){

             DocumentSnapshot userdoc=Snapshots.data.docs[index];

             return Card(

               elevation: 8.0,
               child: ListTile(

                 leading: CircleAvatar(

                   backgroundColor: Colors.white,
                   backgroundImage: NetworkImage(userdoc.data()['profilepic']),
                 ),

                 title: Text(userdoc.data()['username'],style: MyStyle(25,Colors.black,FontWeight.w700),),
                 trailing: InkWell(

                   onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUser(userdoc['uid']))),
                   child: Container(

                     width: 90,
                     height: 40,
                     decoration: BoxDecoration(

                       borderRadius: BorderRadius.circular(20),
                       color: Colors.lightBlue,
                       
                     ),
                     child: Center(

                       child: Text("View",style: MyStyle(20),),
                     ),

                   ),
                 ),
                
                 ),
             );
           }
           );

       }
     }
     ),
    );
  }
}