import 'dart:io';

import 'package:Grab_Link/screens/AddLinkPage.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({Key key}) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color.fromRGBO(158, 115, 200, 1),
                      Color.fromRGBO(245, 185, 194, 1),
                    ])),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "SCAN QR\n",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                          ),
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(4),
                              width: 300,
                              height: 300,
                              child: QRView(
                                key: qrKey,
                                onQRViewCreated: _onQRViewCreated,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: IconButton(
                                onPressed: () async {
                                  await controller.toggleFlash();
                                },
                                color: Colors.white,
                                icon: Icon(Icons.flash_on_sharp)),
                          )
                        ],
                      ),
                      result == null
                          ? Column(
                              children: [
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Text("Looking for QR Code"),
                                )
                              ],
                            )
                          : Column(children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 14),
                                width: 300,
                                child: MaterialButton(
                                  elevation: 0,
                                  textColor: Colors.white,
                                  color: Color.fromRGBO(150, 115, 200, 1),
                                  onPressed: () async {
                                    print(result.code);
                                    bool canLaunchRes =
                                        await canLaunch(result.code);
                                    if (canLaunchRes) {
                                      await launch(result.code);
                                    } else {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Text Content"),
                                          content: Text(result.code),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Okay"))
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Launch Link"),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 14),
                                  width: 300,
                                  child: MaterialButton(
                                    textColor: Colors.white,
                                    elevation: 0,
                                    color: Color.fromRGBO(150, 115, 200, 1),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddLinkPage(result.code)));
                                    },
                                    child: Text("Save Link"),
                                  ))
                            ])
                    ]))));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
