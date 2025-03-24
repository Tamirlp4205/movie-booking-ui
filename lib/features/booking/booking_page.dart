import 'package:flutter/material.dart';

import './widgets/widgets.dart';
import './animations/animations.dart';
import '../../core/data/models/movies.dart';
import '../../core/constants/constants.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin {
  late final BookingPageAnimationController _controller;

  @override
  void initState() {
    _controller = BookingPageAnimationController(
      buttonController: AnimationController(
        duration: const Duration(milliseconds: 750),
        vsync: this,
      ),
      contentController: AnimationController(
        duration: const Duration(milliseconds: 750),
        vsync: this,
      ),
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _controller.buttonController.forward();
      await _controller.buttonController.reverse();
      await _controller.contentController.forward();
    });
    super.initState();
  }

  // 🛠 Захиалга баталгаажуулах функц
  void _confirmBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.movie.name} киноны захиалга амжилттай!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAnimatedOpacity(
            animation: _controller.topOpacityAnimation,
            child: MovieAppBar(title: widget.movie.name),
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              width: w,
              height: h * .9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Spacer(),
                    CustomAnimatedOpacity(
                      animation: _controller.topOpacityAnimation,
                      child: SizedBox(
                        height: h * .075,
                        child: MovieDates(dates: widget.movie.dates),
                      ),
                    ),
                    const Spacer(),
                    CustomAnimatedOpacity(
                      animation: _controller.topOpacityAnimation,
                      child: SizedBox(
                        height: h * .2,
                        width: w,
                        child: MovieTheaterScreen(
                          image: widget.movie.image,
                          maxHeight: h,
                          maxWidth: w,
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    CustomAnimatedOpacity(
                      animation: _controller.bottomOpacityAnimation,
                      child: MovieSeats(seats: widget.movie.seats),
                    ),
                    const Spacer(),
                    CustomAnimatedOpacity(
                      animation: _controller.bottomOpacityAnimation,
                      child: const MovieSeatTypeLegend(),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
            // 🛠 Биометрик устгаад, зөвхөн захиалгын товч үлдээв
            Positioned(
              bottom: h * .05,
              child: ElevatedButton(
                onPressed: _confirmBooking, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.3, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Захиалах',
                  style: AppTextStyles.bookButtonTextStyle,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
