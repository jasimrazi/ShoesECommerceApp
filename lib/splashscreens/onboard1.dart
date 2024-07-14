import 'package:flutter/material.dart';
import 'package:shoesapp/splashscreens/onboard3.dart';
import 'package:shoesapp/widget/elevated_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shoesapp/splashscreens/onboard2.dart';

class Onboard1 extends StatefulWidget {
  const Onboard1({Key? key}) : super(key: key);

  @override
  _Onboard1State createState() => _Onboard1State();
}

class _Onboard1State extends State<Onboard1> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      // Navigate to Onboard2 page when reaching the end
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Onboard2()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.7, // Set a fixed height or use an Expanded widget
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Transform.rotate(
                            angle: -0.3,
                            child: Image.asset(
                              'assets/images/shoe1.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Start Journey With Nike',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Smart, Gorgeous & Fashionable Collection',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff707B81),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      // Add Onboard2 with its own shoe image and text
                      Onboard2(),
                      Onboard3(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3, // Number of pages
                    effect: ExpandingDotsEffect(
                      activeDotColor: Color(0xff5B9EE1),
                      dotColor: Color(0xffE5EEF7),
                      dotHeight: 8,
                      dotWidth: 11,
                      expansionFactor: 4.0,
                    ), // Choose your desired effect
                  ),
                  CustomElevatedButton(
                    onPressed: nextPage,
                    text: _currentPage < 1 ? 'Get Started' : 'Next',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
