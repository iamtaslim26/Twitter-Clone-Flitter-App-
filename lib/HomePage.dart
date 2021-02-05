import 'package:FlitterApp/Pages/ProfilePage.dart';
import 'package:FlitterApp/Pages/SearchPage.dart';
import 'package:FlitterApp/Pages/TweetPage.dart';
import 'package:FlitterApp/utilize/Variables.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  
  @override

  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  int page=0;

  List PageOptions=[

      TweetPage(),
      SearchPage(),
      ProfilePage()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(

     body: PageOptions[page],
      bottomNavigationBar: BottomNavigationBar(

        onTap: (index){

          setState(() {
            page=index;
          });
          
        },

        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        currentIndex: page,
        items: [


          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 20,),
            title: Text("Tweets",style: MyStyle(20),),    
        
        ),

        
          BottomNavigationBarItem(
            icon: Icon(Icons.search,size: 20,),
            title: Text("Search",style: MyStyle(20),),    
        
        ),

        
          BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 20,),
            title: Text("Profile",style: MyStyle(20),),    
        
        ),
        ],
        
        ),
      
    );
  }
}