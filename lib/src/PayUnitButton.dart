import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:styled_widget/styled_widget.dart';

class PayButton extends StatefulWidget {
  final Function pressEvent;
  final String text;
  final IconData icon;
  final double width;
  final bool isFixedHeight;
  final Color color;

  const PayButton(
      {@required this.pressEvent,
        this.text,
        this.icon,
        this.color,
        this.isFixedHeight = true,
        this.width = double.infinity});
  @override
  _PayButtonState createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> with AnimationMixin {
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final curveAnimation = CurvedAnimation(
        parent: controller, curve: Curves.easeIn, reverseCurve: Curves.easeIn);
    _scale = Tween<double>(begin: 1, end: 0.9).animate(curveAnimation);
  }
  void _onTapDown(TapDownDetails details) {
    controller.play(duration: Duration(milliseconds: 150));
  }

  void _onTapUp(TapUpDetails details) {
    if (controller.isAnimating) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed)
          controller.playReverse(duration: Duration(milliseconds: 100));
      });
    } else
      controller.playReverse(duration: Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => PayDialog(),
        );
      },
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        controller.playReverse(
          duration: Duration(milliseconds: 100),
        );
      },
      child: Transform.scale(
        scale: _scale.value,
        child: _animatedButtonUI,
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
    height: widget.isFixedHeight ? 50.0 : null,
    width: widget.width,
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: widget.color ?? Theme.of(context).primaryColor),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.icon != null
            ? Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Icon(
            widget.icon,
            color: Colors.white,
          ),
        )
            : SizedBox(),
        SizedBox(
          width: 5,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${widget.text}',
            // maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

class PayDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('サインアップ') // button
            .textColor(Colors.white)
            .fontSize(24)
            .padding(vertical: 15, horizontal: 30)
            .decorated(
          color: Color(0xff41508D),
          borderRadius: BorderRadius.circular(35),
        )
            .gestures(onTap: () => Navigator.pop(context)),
        Text('サインイン') // bottom description
            .fontSize(18)
            .textColor(Color(0xff455178))
            .padding(vertical: 30),
      ],
    ).constrained(
      height: 280,
      width: MediaQuery.of(context).size.width,
    )
        .padding(all: 10)
        .backgroundBlur(20)
        .clipRect();
  }
}