import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

class FeatureButton extends StatefulWidget {
  final Widget icon;
  final Function onPressed;
  final String featureId;
  final String titlText;
  final String mainText;
  final String mainText2;

  FeatureButton(
      {Key key,
      @required this.icon,
      @required this.onPressed,
      @required this.featureId,
      this.titlText,
      this.mainText,
      this.mainText2})
      : super(key: key);

  @override
  _FeatureButtonState createState() => _FeatureButtonState();
}

class _FeatureButtonState extends State<FeatureButton> {
  var feature1OverflowMode = OverflowMode.clipContent;
  var feature1EnablePulsingAnimation = false;
  var feature3ItemCount = 15;
  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      onComplete: () async {
        return true;
      },
      featureId: widget.featureId,
      tapTarget: widget.icon,
      backgroundColor: Colors.red[800],
      title: Text(widget.titlText),
      overflowMode: feature1OverflowMode,
      enablePulsingAnimation: feature1EnablePulsingAnimation,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.mainText),
          Text(widget.mainText2),
        ],
      ),
      child: IconButton(
        icon: widget.icon,
        onPressed: () {
          FeatureDiscovery.discoverFeatures(
            context,
            <String>{widget.featureId},
          );
        FeatureDiscovery.isDisplayed(context, widget.featureId).then((value) => {
          if(value){widget.onPressed()}
          else {print('done....')}
            
        });
       
        },
      ),
    );
  }
}
