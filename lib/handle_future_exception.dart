import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;

  final Function action;

  final String actionText;

  final String statusText;

  const StatusWidget({
    Key key,
    @required this.snapshot,
    @required this.actionText,
    this.statusText,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
          backgroundColor: Colors.white,
          strokeWidth: 2.1,
        ),
      );
    }

    if (snapshot.hasError &&
        snapshot.connectionState == ConnectionState.active) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(statusText ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
            Visibility(
              visible: action != null,
              child: InkWell(
                child: Icon(
                  Icons.refresh_outlined,
                  size: 50,
                  color: Colors.grey[400],
                ),
                onTap: action,
              ),
            )
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(statusText ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16)),
          Visibility(
            visible: action != null,
            child: InkWell(
              child: Icon(
                Icons.refresh_outlined,
                size: 50,
                color: Colors.grey[400],
              ),
              onTap: action,
            ),
          )
        ],
      ),
    );
  }
}
