import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ordencompra/utils/constants/onboard_content.dart';

import '../../utils/constants/colors.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreen();
}

class _OnboardingScreen extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            width: double.infinity,
            margin: EdgeInsets.only(top: 45, right: 30),
            child: MaterialButton(
              onPressed: () async {
                if (currentIndex == contents.length - 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignUpScreen()));
                }
                _controller.jumpToPage(4);
              },
              child: Text(
                currentIndex == contents.length - 1 ? "" : "Saltar",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: 'Roman',
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    decorationThickness: 1,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.all(10),
                            child: Image.asset(
                              contents[i].image,
                              height: 250,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(right: 15, left: 15),
                            child: Text(
                              contents[i].text,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'knockout',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            contents[i].descripcion,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                color: tDescrip,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length, (index) => buildPage(index, context)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    alignment: Alignment.bottomLeft,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 40, bottom: 50),
                    child: MaterialButton(
                      onPressed: () async {
                        _controller.previousPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOut);
                      },
                      child: Text(
                        currentIndex == 0 ? "" : "Anterior",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'Roman',
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            decorationThickness: 1,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 90,
                    alignment: Alignment.bottomRight,
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 40, bottom: 50),
                    child: MaterialButton(
                      onPressed: () async {
                        if (currentIndex == contents.length - 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SignUpScreen()));
                        }
                        _controller.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOut);
                      },
                      child: Text(
                        currentIndex == contents.length - 1 ? "" : "Siguiente",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'Roman',
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            decorationThickness: 1,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: currentIndex == contents.length - 1
          ? Container(
              width: 300,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: Container(
                  height: 48.0,
                  width: 280,
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: 60),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.0),
                      child: Text(
                        'Empezar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }

  Container buildPage(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 10 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? Colors.green
            : Colors.black.withOpacity(0.2),
      ),
    );
  }
}
