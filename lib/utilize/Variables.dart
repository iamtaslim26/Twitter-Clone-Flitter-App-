

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


MyStyle(double size,[Color color,FontWeight fw]){


return GoogleFonts.montserrat(

  fontSize: size,
  fontWeight: fw,
  color: color
);

}
 
CollectionReference usercollection=Firestore.instance.collection('Users');
CollectionReference tweetCollection=Firestore.instance.collection('Tweets');
Reference pictureTweet = FirebaseStorage.instance.ref().child('Tweet Pictures');


var exampleImage='https://www.google.com/search?q=image+of+shahrukh+khan&sxsrf=ALeKk02MS9vH-t5WUlym6OvHCNjgvvJMnQ:1607523085275&tbm=isch&source=iu&ictx=1&fir=_AXSRYlIH_e5_M%252CylazlszL_GxIZM%252C_&vet=1&usg=AI4_-kSacGx05qrAP3IFGdev0dYqD2JdUQ&sa=X&ved=2ahUKEwi549yTisHtAhUMzTgGHZTWC2gQ9QF6BAgQEAE&biw=1163&bih=554#imgrc=RMe92ojdKf5ZPM';


