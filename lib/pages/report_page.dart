import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9DD7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Laporan",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Konten laporan dengan animasi
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      4,
                      (index) => ReportCardAnimated(
                        width: constraints.maxWidth < 500 ? double.infinity : 300,
                        title: "Konten Laporan #${index + 1}",
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReportCardAnimated extends StatefulWidget {
  final double width;
  final String title;

  const ReportCardAnimated({
    super.key,
    required this.width,
    required this.title,
  });

  @override
  State<ReportCardAnimated> createState() => _ReportCardAnimatedState();
}

class _ReportCardAnimatedState extends State<ReportCardAnimated> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: widget.width,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
