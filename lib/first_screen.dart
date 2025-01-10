import 'package:fieldr_project/sign_in.dart';
//import 'package:fieldr/utils/colors.dart';
import 'package:flutter/material.dart';

import 'signup_screen.dart';

//import 'signup_screen.dart';

class MyFirstScreen extends StatelessWidget {
  const MyFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack( children:[
        Container
            (
            height: size.height,
            width: size.width,
            decoration:  BoxDecoration(
             image: DecorationImage(
              image: const AssetImage("images/front_image.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
                )
              
              )
            ),            
            ),
         
          Positioned(
            top: size.height*0.4,
            left: 0,
            right: 0,
            child:  Center(
              child: Column(
              children: [
                Text('Fieldr', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 48, 
                  color: Colors.white.withOpacity(0.9), 
                  height: 1.2),),

                const SizedBox(height: 20),

                Text('Where Every Match Begins', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 35, 
                  color: Colors.white.withOpacity(0.9), 
                  height: 1.2),),

                const SizedBox(height: 25),

                const Text('Unite, Book And Hit the Field', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: Colors.white70, 
                  ),
                  ),
                  SizedBox(height: size.height*0.07),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: Container(
                      height: size.height* 0.08,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //color: imageBckClr.withOpacity(0.3),
                        color: const Color(0xFF293232).withOpacity(0.3),
                        border: Border.all(color: const Color(0xFF293232)),
                        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05),
                        spreadRadius: 1, blurRadius: 7, offset: const Offset(0,-1),
                        )
                        
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Row(children: [
                          Container(height: size.height*0.08,
                          width: size.width / 2.2,
                          decoration: BoxDecoration(
                            //color: imageBckClr,
                            color: const Color(0xFF293232),
                            borderRadius: BorderRadius.circular(10)

                          ),

                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const MySignupPage())
                                );
                           },
                     child: const Center(
                            child: Text("Register", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 229, 223, 223),
                            ),),
                          ),
                          ),
                          
                          

                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SignIn())
                                );
                            },
                            child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 229, 223, 223), ),),
                          ),
                          const Spacer(),
                        ],),
                      ),

                    )
                  )
              ],
                        ),
            ) )
        ],
        
        ),

   
      
    );
     }
  }
