import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nsio_flutter/screens/location/google_maps_service.dart';
import 'package:nsio_flutter/themes/app_theme.dart';
import 'package:nsio_flutter/utils/sizes.dart';

class SelectPredictionWidget extends StatelessWidget {
  final PlacePrediction placePrediction;
  final Function onTap;

  const SelectPredictionWidget(
      {Key key, @required this.placePrediction, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s10),
        margin: EdgeInsets.only(top: Sizes.s4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.s25),
          ),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              CupertinoIcons.location,
              size: Sizes.s20,
            ),
            Expanded(
              child: Text(
                placePrediction.description,
                style: TextStyles.defaultRegular.copyWith(
                  fontSize: FontSize.s16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ImageLocationPredictionWidget extends StatelessWidget {
  final PlacePrediction placePrediction;
  final Function onTap;

  const ImageLocationPredictionWidget(
      {Key key, @required this.placePrediction, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s10),
        margin: EdgeInsets.symmetric(vertical: Sizes.s8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.s25),
          ),
          color: Colors.grey,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    placePrediction.name,
                    style: TextStyles.defaultRegular.copyWith(
                      fontSize: FontSize.s18,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    placePrediction.description,
                    style: TextStyles.defaultRegular.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectPredictionWithDescriptionWidget extends StatelessWidget {
  final PlacePrediction placePrediction;

  final Function onTap;

  const SelectPredictionWithDescriptionWidget({
    Key key,
    @required this.placePrediction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: Sizes.s15, vertical: Sizes.s10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              placePrediction.name,
              style: TextStyles.defaultRegular.copyWith(
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.start,
            ),
            Text(
              placePrediction.description,
              style: TextStyles.defaultRegular.copyWith(),
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }
}
