import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/widgets/common/panel_container_widget.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.standardSpacing,
            horizontal: Dimensions.halfStandardSpacing,
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.doubleStandardSpacing,
                  ),
                  child: Text('AUTHOR'),
                ),
              ),
              SizedBox(
                height: Dimensions.halfStandardSpacing,
              ),
              PanelContainer(
                borderRadius: Styles.defaultCornerRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.standardSpacing,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Styles.defaultCornerRadius),
                      child: Image(
                        image: AssetImage('assets/mikolaj_profile_picture.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('Mikolaj Kieres'),
                    subtitle: Text('feedback@progrunning.net'),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.doubleStandardSpacing,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.doubleStandardSpacing,
                  ),
                  child: Text('DESIGN & ART'),
                ),
              ),
              SizedBox(
                height: Dimensions.halfStandardSpacing,
              ),
              PanelContainer(
                borderRadius: Styles.defaultCornerRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.standardSpacing,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Styles.defaultCornerRadius),
                      child: Image(
                        image: AssetImage('assets/adamkiewiczart_logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('Alicja Adamkiewicz'),
                    subtitle: Text('adamkiewiczart.com/'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
