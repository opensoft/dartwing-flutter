import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../network/paper_trail.dart';
import 'widgets/base_scaffold.dart';

class ScannerPage extends StatefulWidget {
  final String pageTitle;
  final bool manualInputAllowed;

  const ScannerPage(
      {super.key, required this.pageTitle, required this.manualInputAllowed});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController _textController = TextEditingController();

  void _sendCode(String data,
      {String inputDevice = "", bool isEnteredManually = false}) {
    PaperTrailClient.sendInfoMessageToPaperTrail(
        'QR or barcode ($inputDevice): $data');
    controller.stop();
    Navigator.of(context).pop(data);
  }

  @override
  void dispose() {
    _textController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!mounted) {
      return;
    }
    Barcode? barcode = barcodes.barcodes.firstOrNull;
    if (barcode != null) {
      _sendCode(barcode.rawValue ?? "", inputDevice: "camera");
    }
  }

  Widget _cameraOrScannerView() {
    if (Platform.isAndroid || Platform.isIOS) {
      return Stack(
        children: [
          Center(
            child: MobileScanner(
              onDetect: _handleBarcode,
              controller: controller,
              overlayBuilder: (context, constraints) {
                return Container(
                  decoration: ShapeDecoration(
                    shape: OverlayShape(
                      borderRadius: 10,
                      borderColor: Colors.white,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 250,
                      cutOutBottomOffset: 0,
                      overlayColor: const Color.fromRGBO(0, 0, 0, 80),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ToggleFlashlightButton(controller: controller),
            ),
          ),
        ],
      );
    }
    return Text(
      widget.pageTitle,
      style: const TextStyle(fontSize: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      loadingOverlayEnabled: false,
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      onBarcodeFetched: (String barcode) {
        Navigator.of(context).pop(barcode);
      },
      body: Column(children: [
        Expanded(
          child: _cameraOrScannerView(),
        ),
        Visibility(
          visible: widget.manualInputAllowed,
          child: Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Enter barcode'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(20),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: _textController.text.isEmpty
                        ? null
                        : () {
                            _sendCode(_textController.text,
                                inputDevice: "manually",
                                isEnteredManually: true);
                          },
                    child: const Text("->",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                        ))),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.9)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (BuildContext context, MobileScannerState state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const Icon(
              Icons.no_flash,
              color: Colors.grey,
            );
        }
      },
    );
  }
}

class OverlayShape extends ShapeBorder {
  /// Color of the border.
  final Color borderColor;

  /// Width of the border.
  final double borderWidth;

  /// Color of the overlay.
  final Color overlayColor;

  /// Radius of the border.
  final double borderRadius;

  /// Length of the border.
  final double borderLength;

  /// Width of the cut out.
  final double cutOutWidth;

  /// Height of the cut out.
  final double cutOutHeight;

  /// Bottom offset of the cut out.
  final double cutOutBottomOffset;

  OverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 4.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 42,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 250,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 250 {
    assert(
      borderLength <=
          min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
      "Border can't be larger than ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );
    assert(
        (cutOutWidth == null && cutOutHeight == null) ||
            (cutOutSize == 0.0 && cutOutWidth != null && cutOutHeight != null),
        'Use only cutOutWidth and cutOutHeight or only cutOutSize');
  }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final bLength =
        borderLength > min(cutOutHeight, cutOutHeight) / 2 + borderWidth * 2
            ? borderWidthSize / 2
            : borderLength;
    final cutWidth = cutOutWidth < width ? cutOutWidth : width - borderOffset;
    final cutHeight =
        cutOutHeight < height ? cutOutHeight : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - cutWidth / 2 + borderOffset,
      -cutOutBottomOffset +
          rect.top +
          height / 2 -
          cutHeight / 2 +
          borderOffset,
      cutWidth - borderOffset * 2,
      cutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )

      /// Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - bLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + bLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )

      /// Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + bLength,
          cutOutRect.top + bLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )

      /// Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - bLength,
          cutOutRect.bottom - bLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )

      /// Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - bLength,
          cutOutRect.left + bLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return OverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
