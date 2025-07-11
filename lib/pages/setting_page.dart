import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    final InputDecoration inputDecoration = InputDecoration(
      hintText: "Tulis",
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );

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
                      "Pengaturan",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Box Form
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Batas Sensor",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            AnimatedInputField("Minimum pH Air:", inputDecoration, labelStyle),
                            AnimatedInputField("Maksimum pH Air:", inputDecoration, labelStyle),
                            AnimatedInputField("Minimum Suhu Air:", inputDecoration, labelStyle),
                            AnimatedInputField("Maksimum Suhu Air:", inputDecoration, labelStyle),
                            AnimatedInputField("Minimum TDS:", inputDecoration, labelStyle),
                            AnimatedInputField("Maksimum TDS:", inputDecoration, labelStyle),
                            AnimatedInputField("Minimum Water Level:", inputDecoration, labelStyle),
                            AnimatedInputField("Maksimum Water Level:", inputDecoration, labelStyle),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Tombol Simpan
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("Batas sensor tersimpan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18)),
                                  content: const Text(
                                    "Data berhasil disimpan.\nTekan OK untuk melanjutkan.",
                                    textAlign: TextAlign.center,
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF9DD7FA),
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 10),
                                      ),
                                      child: const Text("OK", style: TextStyle(fontSize: 16)),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text("Simpan"),
                          ),
                        )
                      ],
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

/// Widget input field yang diberi animasi saat disentuh
class AnimatedInputField extends StatefulWidget {
  final String label;
  final InputDecoration decoration;
  final TextStyle style;

  const AnimatedInputField(this.label, this.decoration, this.style, {super.key});

  @override
  State<AnimatedInputField> createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<AnimatedInputField> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: widget.style),
              const SizedBox(height: 4),
              TextField(decoration: widget.decoration),
            ],
          ),
        ),
      ),
    );
  }
}
