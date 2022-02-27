import 'package:feature_discovery/feature_discovery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'bloc/account_bloc.dart';
import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';
import 'dart:typed_data';
import 'dart:io';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _screenshotController = ScreenshotController();
  @override
  void _takeScreenshot() async {
    final uint8List = await _screenshotController.capture();
    final paths = await getApplicationDocumentsDirectory();
    File file = File('${paths.path}/image.png');
    await file.writeAsBytes(uint8List!);
    await Share.shareFiles([file.path]);
  }

  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
              featureId: '0', // Unique id that identifies this overlay.
              tapTarget: const Icon(Icons
                  .share), // The widget that will be displayed as the tap target.
              title: Text('Share'),
              description: Text('Share a screenshot.'),
              backgroundColor: Theme.of(context).primaryColor,
              targetColor: Colors.white,
              textColor: Colors.white,
              child: IconButton(
                tooltip: "Compartir pantalla",
                onPressed: _takeScreenshot,
                icon: Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<PictureBloc, PictureState>(
                  listener: (context, state) {
                    if (state is PictureErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${state.errorMsg}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PictureSelectedState) {
                      return CircleAvatar(
                        backgroundImage: FileImage(state.picture!),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 122, 113, 113),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Bienvenido",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text("Usuario${UniqueKey()}"),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DescribedFeatureOverlay(
                      featureId: '1', // Unique id that identifies this overlay.
                      tapTarget: const Icon(Icons
                          .credit_card), // The widget that will be displayed as the tap target.
                      title: Text('Cards'),
                      description: Text('Your cards.'),
                      backgroundColor: Theme.of(context).primaryColor,
                      targetColor: Colors.white,
                      textColor: Colors.white,
                      child: CircularButton(
                        textAction: "Ver tarjeta",
                        iconData: Icons.credit_card,
                        bgColor: Color(0xff123b5e),
                        action: null,
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: '2', // Unique id that identifies this overlay.
                      tapTarget: const Icon(Icons
                          .camera_alt), // The widget that will be displayed as the tap target.
                      title: Text('Picture'),
                      description: Text('Change picture.'),
                      backgroundColor: Theme.of(context).primaryColor,
                      targetColor: Colors.white,
                      textColor: Colors.white,
                      child: CircularButton(
                        textAction: "Cambiar foto",
                        iconData: Icons.camera_alt,
                        bgColor: Colors.orange,
                        action: () {
                          BlocProvider.of<PictureBloc>(context).add(
                            ChangeImageEvent(),
                          );
                        },
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: '3', // Unique id that identifies this overlay.
                      tapTarget: const Icon(Icons
                          .play_arrow), // The widget that will be displayed as the tap target.
                      title: Text('Tutorial'),
                      description: Text('Play this tutorial again.'),
                      backgroundColor: Theme.of(context).primaryColor,
                      targetColor: Colors.white,
                      textColor: Colors.white,
                      child: CircularButton(
                        textAction: "Ver tutorial",
                        iconData: Icons.play_arrow,
                        bgColor: Colors.green,
                        action: () {
                          FeatureDiscovery.clearPreferences(context, <String>{
                            '0', // Feature ids for every feature that you want to showcase in order.
                            '1',
                            '2',
                            '3',
                          });
                          FeatureDiscovery.discoverFeatures(
                            context,
                            const <String>{
                              '0', // Feature ids for every feature that you want to showcase in order.
                              '1',
                              '2',
                              '3',
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                BlocConsumer<AccountBloc, AccountState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is AccountSuccess) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.data["hoja1"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return CuentaItem(
                            tipoCuenta:
                                state.data["hoja1"][index]["cvv"].toString(),
                            terminacion: state.data["hoja1"][index]["cuenta"]
                                .toString()
                                .substring(5, 9),
                            saldoDisponible:
                                state.data["hoja1"][index]["dinero"].toString(),
                          );
                        },
                      );
                    } else if (state is AccountError) {
                      return Text("No hay cuentas");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
