import 'package:FlitterApp/utilize/Variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SignupPage.dart';
import 'HomePage.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}


class _NavigationPageState extends State<NavigationPage> {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  bool isSignedin=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _auth.onAuthStateChanged.listen((userInfo) { 

        if(userInfo!=null){

          setState(() {
            
            isSignedin=true;
          });
        }
        else{

          setState(() {
            isSignedin=false;
          });
        }

    });
  }

  
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
     
   
      body: isSignedin ==false? Login():HomePage(),
    ); 
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}



class _LoginState extends State<Login> {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  var emailController=TextEditingController();
  var passwordController=TextEditingController();


  


  PlzLogin(){

    _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

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
                Text("Login",
                
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

                    controller: emailController,
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

                  width: MediaQuery.of(context).size.width/2,
                  height: 50.0,

                  child: RaisedButton(
                    onPressed: ()=>PlzLogin(),
                    
                    child: Text("Login",
                    style: MyStyle(20.0,Colors.white,FontWeight.w600),
                    
                    
                    ),
                    
                    
                    ),
                    

                ),
                SizedBox(height: 30.0,),

                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Text("Don'thave an account?",style: MyStyle(20),),

                  SizedBox(width: 10,),
                  InkWell(

                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage())),
                    child:
                    Text("Register",style: MyStyle(20.0,Colors.purple,FontWeight.w700),)
                  )
                    
                    

                  ],
                )

                
              

 

                






          ],

        ),
      ),
      
    );
  }
}