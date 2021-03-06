import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({
    Key key,
    this.label,
    this.iconData,
    this.buttonLabel,
    this.buttonOnPress,
    this.color,
    this.scaffoldColor,
  }) : super(key: key);

  final String label, buttonLabel;
  final IconData iconData;
  final Function buttonOnPress;
  final Color color, scaffoldColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          scaffoldColor == null ? Colors.transparent : scaffoldColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  iconData == null
                      ? Container()
                      : Icon(
                          iconData,
                          color: color,
                          size: size.height * 0.1,
                        ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            buttonLabel == null
                ? Container()
                : RaisedButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.2,
                      vertical: 20,
                    ),
                    child: Text(
                      buttonLabel,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: buttonOnPress,
                  ),
          ],
        ),
      ),
    );
  }
}
