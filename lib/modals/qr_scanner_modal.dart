import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/state/app_state.dart';
import 'package:zilpay/theme/app_theme.dart';

void showQRScannerModal({
  required BuildContext context,
  required Function(String) onScanned,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    useSafeArea: true,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.94,
        child: _QRScannerModalContent(onScanned: onScanned),
      );
    },
  );
}

class _QRScannerModalContent extends StatefulWidget {
  final Function(String) onScanned;

  const _QRScannerModalContent({required this.onScanned});

  @override
  State<_QRScannerModalContent> createState() => _QRScannerModalContentState();
}

class _QRScannerModalContentState extends State<_QRScannerModalContent>
    with WidgetsBindingObserver {
  MobileScannerController? controller;
  StreamSubscription<BarcodeCapture>? _subscription;
  bool hasError = false;
  String errorMessage = '';
  bool isPermissionGranted = false;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        isPermissionGranted = true;
      });
      _initializeScanner();
    } else {
      setState(() {
        hasError = true;
        errorMessage = 'Camera permission denied';
      });
    }
  }

  Future<void> _initializeScanner() async {
    try {
      controller = MobileScannerController(
        facing: CameraFacing.back,
        detectionSpeed: DetectionSpeed.normal,
        formats: [BarcodeFormat.qrCode],
        autoStart: false,
      );

      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      await controller!.start();

      _subscription = controller!.barcodes.listen(_handleBarcode);

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      setState(() {
        isCameraInitialized = true;
        hasError = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        errorMessage = 'Camera initialization error: ${e.toString()}';
      });
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (!mounted) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        widget.onScanned(code);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _toggleTorch() async {
    await controller?.toggleTorch();
    setState(() {});
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (hasError || !isPermissionGranted || controller == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _reactivateCamera();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _deactivateCamera();
        break;
      default:
        break;
    }
  }

  Future<void> _reactivateCamera() async {
    try {
      _subscription?.cancel();

      await controller?.start();

      if (!mounted) return;

      _subscription = controller?.barcodes.listen(_handleBarcode);

      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        errorMessage = 'Failed to restart camera: ${e.toString()}';
      });
    }
  }

  void _deactivateCamera() {
    _subscription?.cancel();
    controller?.stop();
    if (mounted) {
      setState(() {
        isCameraInitialized = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.currentTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: theme.modalBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          const SizedBox(height: 20),
          !isPermissionGranted
              ? _buildPermissionDeniedView()
              : hasError
                  ? _buildErrorView()
                  : _buildScannerView(theme),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader(AppTheme theme) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: theme.modalBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Scan',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset(
                  'assets/icons/close.svg',
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(theme.textPrimary, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/camera.svg',
              width: 64,
              height: 64,
              colorFilter:
                  const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
            ),
            const SizedBox(height: 24),
            const Text('Camera Permission Required',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            const Text('Please grant camera permission to use the scanner.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _openAppSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Open Settings',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _requestCameraPermission,
              child: const Text('Retry',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/error.svg',
              width: 64,
              height: 64,
              colorFilter:
                  const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
            ),
            const SizedBox(height: 24),
            const Text('Camera Error',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text(errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializeScanner,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Retry',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView(AppTheme theme) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: controller != null && isCameraInitialized
                  ? MobileScanner(
                      controller: controller!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: controller?.torchEnabled == true
                    ? SvgPicture.asset(
                        'assets/icons/torch_on.svg',
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                            theme.textPrimary, BlendMode.srcIn),
                      )
                    : SvgPicture.asset(
                        'assets/icons/torch_off.svg',
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                            theme.textPrimary, BlendMode.srcIn),
                      ),
                onPressed: _toggleTorch,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
