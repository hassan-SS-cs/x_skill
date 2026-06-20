import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final Function(int) onNavigate;

  const HomePage({super.key, required this.onNavigate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controller to keep track of which page we are on
  PageController _controller = PageController(initialPage: 0);
  Timer? _timer;
  int _currentPage = 0;
  final int _numPages = 3;
  @override
  void initState() {
    super.initState();
    // here we set the periodic time
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _numPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Reset to the first page when reaching the end
      }

      //the animation here
      if (_controller.hasClients) {
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    // 4. Always cancel the timer and dispose the controller to avoid leaks
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //page view
          Expanded(
            child: PageView(
              //set the controller with PageView
              controller: _controller,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text('Banner 1', style: TextStyle(fontSize: 22)),
                  ),
                ),
                Container(
                  color: Colors.yellow,
                  child: Center(
                    child: Text('Banner 2', style: TextStyle(fontSize: 22)),
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Center(
                    child: Text('Banner 3', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ],
            ),
          ),
          //dot indicators
          Container(
            alignment: Alignment(0, 0.60),
            child: SmoothPageIndicator(controller: _controller, count: 3),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                      onPressed: () => widget.onNavigate(1),
                      child: Text('Photos'),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentGeometry.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                      onPressed: () => widget.onNavigate(2),
                      child: Text('Skills'),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                      onPressed: () => widget.onNavigate(3),
                      child: Text('Videos'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
