import 'package:FlitterApp/utilize/Variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'NavigationPage.dart';
import 'HomePage.dart';



class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var usernameController=TextEditingController();

  PlzSignup(){

    _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
    .then((SignedUser){

        
        usercollection.doc(SignedUser.user.uid).set({

          'username':usernameController.text,
          'email':emailController.text,
          'password':passwordController.text,
          'uid':SignedUser.user.uid,
          'profilepic':"null",

        });

    });

   // Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage()));
   Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      backgroundColor: Colors.lightBlue,

      body: Container(
        alignment: Alignment.center,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children:<Widget> [

                Text("Welcome to Flitter App",

                style:MyStyle(25,Colors.white,FontWeight.w600),
                
                
                ),

                SizedBox(height: 20.0,),
                Text("Register",
                
                style: MyStyle(20,Colors.white,FontWeight.w600),
                ),
                SizedBox(height: 20.0,),

                // Container(
                  
                //   height: 64,
                //   width: 64,

                //   child: Image.asset("images/logo.png"),
                // ),
                // SizedBox(height:20.0),
                

                Container(

                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),

                  child: TextField(

                    controller:emailController ,

                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(

                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: MyStyle(15),
                      labelText: 'Email',
                      border:OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(20.0),
                        
                        ),
                        prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),

                Container(

                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),

                  child: TextField(
                    controller: passwordController,

                    obscureText: true,
                    decoration: InputDecoration(

                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Password',
                      labelStyle: MyStyle(15.0),
                      border: OutlineInputBorder(borderRadius:BorderRadius.circular(20.0) ),
                      prefixIcon: Icon(Icons.lock)

                    ),
                    
                  

                  ),
                ),

                SizedBox(height: 20.0,),
                 Container(

                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),

                  child: TextField(

                      controller: usernameController,
                  
                    decoration: InputDecoration(

                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'UserName',
                      labelStyle: MyStyle(15.0),
                      border: OutlineInputBorder(borderRadius:BorderRadius.circular(20.0) ),
                      prefixIcon: Icon(Icons.verified_user),

                    ),
                    
                  

                  ),
                ),

                SizedBox(height: 20.0,),

                Container(

                  width: MediaQuery.of(context).size.width/2,
                  height: 50.0,

                  child: RaisedButton(
                    onPressed:()=>PlzSignup(),
                    
                    child: Text("Register",
                    style: MyStyle(20.0,Colors.white,FontWeight.w600),
                    
                    
                    ),
                    
                    
                    ),
                    

                ),
                SizedBox(height: 30.0,),

                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Text("already have an accout?",style: MyStyle(20),),

                  SizedBox(width: 10,),
                  InkWell(

                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationPage())),
                    child:
                    Text("Login",style: MyStyle(20.0,Colors.purple,FontWeight.w700),)
                  )
                    
                    

                  ],
                )

                
              

 

                






          ],

        ),
      ),
      
    );
  }
}