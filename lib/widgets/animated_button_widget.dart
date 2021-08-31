import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String initialText, finalText;
  final ButtonAnimStyle buttonAnimStyle;
  final IconData iconData;
  final double iconSize;
  final Duration animationDuration;
  final Function onTap;

  AnimatedButton({
     this.initialText,
     this.finalText,
     this.iconData,
     this.iconSize,
     this.animationDuration, 
     this.buttonAnimStyle,
     this.onTap
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>  with TickerProviderStateMixin{
  AnimationController _controller;
  ButtonState _currentState;
  Duration _smallDuration;
  Animation<double> _scaleFinalTextAnimation;

  @override
  void initState() {
    super.initState();
    _currentState = ButtonState.SHOW_ONLY_TEXT;
    _smallDuration = Duration(milliseconds: (widget.animationDuration.inMilliseconds * 0.2).round());
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _controller.addListener((){
      double _controllerValue = _controller.value;
      if (_controllerValue < 0.2){
        setState(() {
        _currentState = ButtonState.SHOW_ONLY_ICON;
        });
      } else if ( _controllerValue> 0.8){
        setState(() {
        _currentState = ButtonState.SHOW_TEXT_ICON;
        });
      }
    });

    _scaleFinalTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener((currentStatus){
      if (currentStatus == AnimationStatus.completed){
        return widget.onTap();
      }
    });
    }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(widget.buttonAnimStyle.borderRadius)),
      elevation: widget.buttonAnimStyle.elevation,
      child: InkWell(
        onTap: (){
          _controller.forward();
        },
        child: AnimatedContainer(
          duration: _smallDuration,
          height: widget.iconSize + 16,
          decoration: BoxDecoration(
            color: (_currentState == ButtonState.SHOW_ONLY_ICON) || 
                    _currentState == ButtonState.SHOW_TEXT_ICON
                 ? widget.buttonAnimStyle.secondaryColor 
                 : widget.buttonAnimStyle.pirmaryColor,
            border: Border.all(
              color: (_currentState == ButtonState.SHOW_ONLY_ICON)||
                      _currentState == ButtonState.SHOW_TEXT_ICON
                   ? widget.buttonAnimStyle.pirmaryColor 
                   : Colors.transparent 
                   ),
            borderRadius: BorderRadius.all(Radius.circular(widget.buttonAnimStyle.borderRadius)),
          ),
          padding: EdgeInsets.symmetric(horizontal: (_currentState == ButtonState.SHOW_ONLY_ICON) ? 16.0 : 48.0,
                   vertical: 8.0),
          child: AnimatedSize(
            vsync: this,
            duration: _smallDuration,
            curve: Curves.easeInSine,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
               (_currentState == ButtonState.SHOW_ONLY_ICON || 
                _currentState == ButtonState.SHOW_TEXT_ICON) 
               ? Icon(
                  widget.iconData, 
                  size: widget.iconSize, 
                  color: widget.buttonAnimStyle.pirmaryColor
                  ) :  Container(),
                  SizedBox(
                    width: (_currentState == ButtonState.SHOW_TEXT_ICON) ? 30.0 : 0.0,
                  ),
                  getTextWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget getTextWidget(){
    if (_currentState == ButtonState.SHOW_ONLY_TEXT){
      return Text(
        widget.initialText,
        style: widget.buttonAnimStyle.initialTextStyle,
      );
    }else if (_currentState == ButtonState.SHOW_ONLY_ICON){
      return Container();
    }else{
      return ScaleTransition(
        scale: _scaleFinalTextAnimation,
        child: Text(
          widget.finalText,
          style: widget.buttonAnimStyle.finalTextStyle,
        ),
      );
    }
  }
}

class ButtonAnimStyle{
  final TextStyle initialTextStyle, finalTextStyle;
  final Color pirmaryColor, secondaryColor;
  final double elevation, borderRadius;

  ButtonAnimStyle({ this.initialTextStyle, this.finalTextStyle, this.pirmaryColor, this.secondaryColor, this.elevation, this.borderRadius});
}

enum ButtonState{
    SHOW_ONLY_TEXT,
    SHOW_ONLY_ICON,
    SHOW_TEXT_ICON,
}