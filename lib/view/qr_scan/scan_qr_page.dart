import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_belanjakan/view/payment/payment_verification.dart';
// import 'package:modul_cam_qr_1282/constant/app_constant.dart';
// import 'package:modul_cam_qr_1282/views/camera/camera.dart';
import "package:project_belanjakan/view/qr_scan/scanner_error_widget.dart";
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPageView extends StatefulWidget {
  const BarcodeScannerPageView({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPageView> createState() => _BarcodeScannerPageViewState();
}

class _BarcodeScannerPageViewState extends State<BarcodeScannerPageView>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcodeCapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: [
          cameraView(),
          Container(),
        ],
      ),
    );
  }

  Widget cameraView() {
    return Builder(builder: (context) {
      return Stack(
        children: [
          MobileScanner(
            startDelay: true,
            controller: MobileScannerController(torchEnabled: false),
            fit: BoxFit.contain,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            onDetect: (capture) {
              setBarcodeCapture(capture);
              if (barcodeCapture!.barcodes.first.rawValue!.isNotEmpty &&
                  barcodeCapture!.barcodes.first.rawValue!
                      .startsWith("byr-pb:")) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PaymentVerificationView()));
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      height: 50,
                      child: FittedBox(
                        child: GestureDetector(
                          onTap: () => getURLResult(),
                          child: barcodeCaptureTextResult(context),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  Text barcodeCaptureTextResult(BuildContext context) {
    return Text(
      barcodeCapture?.barcodes.first.rawValue ??
          "scan something & click to copy to clipboard",
      overflow: TextOverflow.fade,
      style: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(color: Colors.white),
    );
  }

  void setBarcodeCapture(BarcodeCapture capture) {
    setState(() {
      barcodeCapture = capture;
    });
  }

  void getURLResult() {
    final qrCode = barcodeCapture?.barcodes.first.rawValue;
    if (qrCode != null) {
      copyToClipboard(qrCode);
    }
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("QR code disalin ke clipboard")),
    );
  }
}
