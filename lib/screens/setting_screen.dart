// // // ignore_for_file: deprecated_member_use

// // import 'dart:math';
// // import 'package:flutter/material.dart';

// // class SettingScreen extends StatefulWidget {
// //   const SettingScreen({super.key});

// //   @override
// //   State<SettingScreen> createState() => _SettingScreenState();
// // }

// // class _SettingScreenState extends State<SettingScreen> {
// //   double movementSpeed = 5;
// //   double soundVolume = 7;
// //   double difficulty = 3;
// //   bool enableSound = true;
// //   bool enableNotifications = true;
// //   bool darkMode = true;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.transparent,
// //       body: Stack(
// //         children: [
// //           // Custom background
// //           CustomPaint(painter: _BackgroundPainter(), size: Size.infinite),
// //           Center(child: buildSettingDialog()),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildSettingDialog() {
// //     return Dialog(
// //       backgroundColor: Colors.transparent,
// //       insetPadding: const EdgeInsets.all(20),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [
// //               Colors.black.withOpacity(0.85),
// //               Colors.deepPurple.shade900.withOpacity(0.9),
// //               Colors.indigo.shade900.withOpacity(0.85),
// //             ],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //           borderRadius: BorderRadius.circular(30),
// //           border: Border.all(
// //             color: Colors.cyanAccent.withOpacity(0.4),
// //             width: 2,
// //           ),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.cyanAccent.withOpacity(0.3),
// //               blurRadius: 30,
// //               spreadRadius: 8,
// //             ),
// //           ],
// //         ),
// //         padding: const EdgeInsets.all(28),
// //         child: Stack(
// //           children: [
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Icon(Icons.settings, size: 45),
// //                 const SizedBox(height: 18),
// //                 ShaderMask(
// //                   shaderCallback:
// //                       (bounds) => const LinearGradient(
// //                         colors: [Colors.cyanAccent, Colors.purpleAccent],
// //                       ).createShader(bounds),
// //                   child: const Text(
// //                     'SETTINGS',
// //                     style: TextStyle(
// //                       fontSize: 30,
// //                       fontWeight: FontWeight.bold,
// //                       letterSpacing: 2,
// //                       color: Colors.white,
// //                       shadows: [
// //                         Shadow(
// //                           color: Colors.black87,
// //                           blurRadius: 10,
// //                           offset: Offset(2, 2),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 30),

// //                 Column(
// //                   children: [
// //                     _buildToggleSetting(
// //                       "Sound",
// //                       enableSound,
// //                       Icons.music_note,
// //                       (value) => setState(() => enableSound = value),
// //                     ),
// //                     _buildToggleSetting(
// //                       "Notifications",
// //                       enableNotifications,
// //                       Icons.notifications,
// //                       (value) => setState(() => enableNotifications = value),
// //                     ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 20),
// //                 Divider(color: Colors.white24, thickness: 1),
// //                 const SizedBox(height: 20),

// //                 _buildSliderSetting(
// //                   "Movement Speed",
// //                   movementSpeed,
// //                   1,
// //                   10,
// //                   Icons.speed,
// //                   Colors.cyanAccent,
// //                   false,
// //                   (value) => setState(() => movementSpeed = value),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 enableSound == true
// //                     ? _buildSliderSetting(
// //                       "Sound Volume",
// //                       soundVolume,
// //                       0,
// //                       10,
// //                       Icons.volume_up,
// //                       Colors.pinkAccent,
// //                       false,
// //                       (value) => setState(() {
// //                         soundVolume = value;
// //                       }),
// //                     )
// //                     : GestureDetector(
// //                       onTap: () {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text("Please enable the sound first"),
// //                           ),
// //                         );
// //                       },
// //                       child: _buildSliderSetting(
// //                         "Sound Volume",
// //                         soundVolume,
// //                         0,
// //                         10,
// //                         Icons.volume_up,
// //                         Colors.pinkAccent,
// //                         true,
// //                         (value) => setState(() {
// //                           // soundVolume = value;
// //                         }),
// //                       ),
// //                     ),
// //                 const SizedBox(height: 20),
// //                 _buildSliderSetting(
// //                   "Difficulty Level",
// //                   difficulty,
// //                   1,
// //                   5,
// //                   Icons.leaderboard,
// //                   Colors.orangeAccent,
// //                   false,
// //                   (value) => setState(() => difficulty = value),
// //                 ),

// //                 const SizedBox(height: 35),

// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     _buildActionButton(
// //                       "CANCEL",
// //                       Icons.close_rounded,
// //                       Colors.redAccent,
// //                       () => Navigator.pop(context),
// //                     ),
// //                     _buildActionButton(
// //                       "APPLY",
// //                       Icons.check_circle_rounded,
// //                       Colors.greenAccent,
// //                       () {
// //                         Navigator.pop(context);
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSliderSetting(
// //     String title,
// //     double value,
// //     double min,
// //     double max,
// //     IconData icon,
// //     Color color,
// //     bool isDisable,
// //     Function(double) onChanged,
// //   ) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Icon(icon, color: color, size: 22),
// //             const SizedBox(width: 8),
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                 color: Colors.white70,
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 10),
// //         SliderTheme(
// //           data: SliderThemeData(
// //             trackHeight: 6,
// //             thumbShape: CustomThumbShape(),
// //             overlayColor: color.withOpacity(0.2),
// //             activeTrackColor: color,
// //             inactiveTrackColor: Colors.white24,
// //             thumbColor: color,
// //             disabledActiveTrackColor: Colors.grey.shade700,
// //             disabledInactiveTrackColor: Colors.grey.shade800,
// //             disabledThumbColor: Colors.grey.shade600,
// //           ),
// //           child: Slider(
// //             value: value,
// //             min: min,
// //             max: max,
// //             divisions: (max - min).toInt(),
// //             label: value.toStringAsFixed(1),
// //             onChanged: isDisable ? null : onChanged, // Disable if true
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildToggleSetting(
// //     String title,
// //     bool value,
// //     IconData icon,
// //     Function(bool) onChanged,
// //   ) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, color: Colors.white70, size: 20),
// //               const SizedBox(width: 8),
// //               Text(
// //                 title,
// //                 style: const TextStyle(color: Colors.white70, fontSize: 15),
// //               ),
// //             ],
// //           ),
// //           Switch(
// //             value: value,
// //             onChanged: onChanged,
// //             activeColor: Colors.cyanAccent,
// //             activeTrackColor: Colors.cyanAccent.withOpacity(0.5),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildActionButton(
// //     String text,
// //     IconData icon,
// //     Color color,
// //     Function() onTap,
// //   ) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [color, Color.lerp(color, Colors.black, 0.4)!],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //           borderRadius: BorderRadius.circular(22),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(icon, color: Colors.white, size: 18),
// //             const SizedBox(width: 8),
// //             Text(
// //               text,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 15,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Slider thumb
// // class CustomThumbShape extends SliderComponentShape {
// //   @override
// //   Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

// //   @override
// //   void paint(
// //     PaintingContext context,
// //     Offset center, {
// //     required Animation<double> activationAnimation,
// //     required Animation<double> enableAnimation,
// //     required bool isDiscrete,
// //     required TextPainter labelPainter,
// //     required RenderBox parentBox,
// //     required SliderThemeData sliderTheme,
// //     required TextDirection textDirection,
// //     required double value,
// //     required double textScaleFactor,
// //     required Size sizeWithOverflow,
// //   }) {
// //     final Canvas canvas = context.canvas;
// //     final Paint paint =
// //         Paint()
// //           ..shader = RadialGradient(
// //             colors: [sliderTheme.thumbColor!, Colors.white],
// //           ).createShader(Rect.fromCircle(center: center, radius: 10));

// //     canvas.drawCircle(center, 9, paint);
// //     canvas.drawCircle(center, 4, Paint()..color = Colors.white);
// //   }
// // }

// // // Futuristic background
// // class _BackgroundPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final Paint bgPaint =
// //         Paint()
// //           ..shader = LinearGradient(
// //             colors: [
// //               Colors.black,
// //               Colors.deepPurple.shade900,
// //               Colors.indigo.shade900,
// //             ],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

// //     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

// //     final center = Offset(size.width / 2, size.height / 2);
// //     final maxRadius = size.width * 0.75;

// //     for (double i = 1; i <= 5; i++) {
// //       canvas.drawCircle(
// //         center,
// //         maxRadius * (i / 5),
// //         Paint()
// //           ..color = Colors.cyanAccent.withOpacity(0.08)
// //           ..style = PaintingStyle.stroke
// //           ..strokeWidth = 1.2,
// //       );
// //     }

// //     final linePaint =
// //         Paint()
// //           ..color = Colors.purpleAccent.withOpacity(0.08)
// //           ..strokeWidth = 1;
// //     for (int i = 0; i < 12; i++) {
// //       final angle = i * (pi / 6);
// //       final dx = center.dx + maxRadius * cos(angle);
// //       final dy = center.dy + maxRadius * sin(angle);
// //       canvas.drawLine(center, Offset(dx, dy), linePaint);
// //     }

// //     final dotPaint = Paint()..color = Colors.cyanAccent.withOpacity(0.35);
// //     for (int i = 0; i < 16; i++) {
// //       final angle = i * (pi / 8);
// //       final radius = maxRadius * 0.65;
// //       final dx = center.dx + radius * cos(angle);
// //       final dy = center.dy + radius * sin(angle);
// //       canvas.drawCircle(Offset(dx, dy), 3.5, dotPaint);
// //     }
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// // }

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SettingScreen extends StatefulWidget {
//   final Function(double)? onSpeedChanged;

//   const SettingScreen({super.key, this.onSpeedChanged});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   double movementSpeed = 5.0;
//   double soundVolume = 7.0;
//   double difficulty = 3.0;
//   bool enableSound = true;
//   bool enableNotifications = true;
//   bool darkMode = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadSettings();
//   }

//   // Load settings from SharedPreferences
//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       movementSpeed = prefs.getDouble('movementSpeed') ?? 5.0;
//       soundVolume = prefs.getDouble('soundVolume') ?? 7.0;
//       difficulty = prefs.getDouble('difficulty') ?? 3.0;
//       enableSound = prefs.getBool('enableSound') ?? true;
//       enableNotifications = prefs.getBool('enableNotifications') ?? true;
//       darkMode = prefs.getBool('darkMode') ?? true;
//     });
//   }

//   // Save settings to SharedPreferences
//   Future<void> _saveSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('movementSpeed', movementSpeed);
//     await prefs.setDouble('soundVolume', soundVolume);
//     await prefs.setDouble('difficulty', difficulty);
//     await prefs.setBool('enableSound', enableSound);
//     await prefs.setBool('enableNotifications', enableNotifications);
//     await prefs.setBool('darkMode', darkMode);
//   }

//   // Apply settings and notify parent
//   void _applySettings() {
//     _saveSettings();
//     if (widget.onSpeedChanged != null) {
//       widget.onSpeedChanged!(movementSpeed);
//     }
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           // Custom background
//           CustomPaint(painter: _BackgroundPainter(), size: Size.infinite),
//           Center(child: buildSettingDialog()),
//         ],
//       ),
//     );
//   }

//   Widget buildSettingDialog() {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.all(20),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.black.withOpacity(0.85),
//               Colors.deepPurple.shade900.withOpacity(0.9),
//               Colors.indigo.shade900.withOpacity(0.85),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(
//             color: Colors.cyanAccent.withOpacity(0.4),
//             width: 2,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.cyanAccent.withOpacity(0.3),
//               blurRadius: 30,
//               spreadRadius: 8,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(28),
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.settings, size: 45),
//                 const SizedBox(height: 18),
//                 ShaderMask(
//                   shaderCallback:
//                       (bounds) => const LinearGradient(
//                         colors: [Colors.cyanAccent, Colors.purpleAccent],
//                       ).createShader(bounds),
//                   child: const Text(
//                     'SETTINGS',
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black87,
//                           blurRadius: 10,
//                           offset: Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),

//                 Column(
//                   children: [
//                     _buildToggleSetting(
//                       "Sound",
//                       enableSound,
//                       Icons.music_note,
//                       (value) => setState(() => enableSound = value),
//                     ),
//                     _buildToggleSetting(
//                       "Notifications",
//                       enableNotifications,
//                       Icons.notifications,
//                       (value) => setState(() => enableNotifications = value),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),
//                 Divider(color: Colors.white24, thickness: 1),
//                 const SizedBox(height: 20),

//                 _buildSliderSetting(
//                   "Movement Speed",
//                   movementSpeed,
//                   1,
//                   10,
//                   Icons.speed,
//                   Colors.cyanAccent,
//                   false,
//                   (value) => setState(() => movementSpeed = value),
//                 ),
//                 const SizedBox(height: 20),
//                 enableSound == true
//                     ? _buildSliderSetting(
//                       "Sound Volume",
//                       soundVolume,
//                       0,
//                       10,
//                       Icons.volume_up,
//                       Colors.pinkAccent,
//                       false,
//                       (value) => setState(() {
//                         soundVolume = value;
//                       }),
//                     )
//                     : GestureDetector(
//                       onTap: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Please enable the sound first"),
//                           ),
//                         );
//                       },
//                       child: _buildSliderSetting(
//                         "Sound Volume",
//                         soundVolume,
//                         0,
//                         10,
//                         Icons.volume_up,
//                         Colors.pinkAccent,
//                         true,
//                         (value) => setState(() {
//                           // soundVolume = value;
//                         }),
//                       ),
//                     ),
//                 const SizedBox(height: 20),
//                 _buildSliderSetting(
//                   "Difficulty Level",
//                   difficulty,
//                   1,
//                   5,
//                   Icons.leaderboard,
//                   Colors.orangeAccent,
//                   false,
//                   (value) => setState(() => difficulty = value),
//                 ),

//                 const SizedBox(height: 35),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildActionButton(
//                       "CANCEL",
//                       Icons.close_rounded,
//                       Colors.redAccent,
//                       () => Navigator.pop(context),
//                     ),
//                     _buildActionButton(
//                       "APPLY",
//                       Icons.check_circle_rounded,
//                       Colors.greenAccent,
//                       _applySettings,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSliderSetting(
//     String title,
//     double value,
//     double min,
//     double max,
//     IconData icon,
//     Color color,
//     bool isDisable,
//     Function(double) onChanged,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: color, size: 22),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         SliderTheme(
//           data: SliderThemeData(
//             trackHeight: 6,
//             thumbShape: CustomThumbShape(),
//             overlayColor: color.withOpacity(0.2),
//             activeTrackColor: color,
//             inactiveTrackColor: Colors.white24,
//             thumbColor: color,
//             disabledActiveTrackColor: Colors.grey.shade700,
//             disabledInactiveTrackColor: Colors.grey.shade800,
//             disabledThumbColor: Colors.grey.shade600,
//           ),
//           child: Slider(
//             value: value,
//             min: min,
//             max: max,
//             divisions: (max - min).toInt(),
//             label: value.toStringAsFixed(1),
//             onChanged: isDisable ? null : onChanged,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildToggleSetting(
//     String title,
//     bool value,
//     IconData icon,
//     Function(bool) onChanged,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.white70, size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: const TextStyle(color: Colors.white70, fontSize: 15),
//               ),
//             ],
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: Colors.cyanAccent,
//             activeTrackColor: Colors.cyanAccent.withOpacity(0.5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(
//     String text,
//     IconData icon,
//     Color color,
//     Function() onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [color, Color.lerp(color, Colors.black, 0.4)!],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(22),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: Colors.white, size: 18),
//             const SizedBox(width: 8),
//             Text(
//               text,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Slider thumb
// class CustomThumbShape extends SliderComponentShape {
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     final Canvas canvas = context.canvas;
//     final Paint paint =
//         Paint()
//           ..shader = RadialGradient(
//             colors: [sliderTheme.thumbColor!, Colors.white],
//           ).createShader(Rect.fromCircle(center: center, radius: 10));

//     canvas.drawCircle(center, 9, paint);
//     canvas.drawCircle(center, 4, Paint()..color = Colors.white);
//   }
// }

// // Futuristic background
// class _BackgroundPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint bgPaint =
//         Paint()
//           ..shader = LinearGradient(
//             colors: [
//               Colors.black,
//               Colors.deepPurple.shade900,
//               Colors.indigo.shade900,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

//     final center = Offset(size.width / 2, size.height / 2);
//     final maxRadius = size.width * 0.75;

//     for (double i = 1; i <= 5; i++) {
//       canvas.drawCircle(
//         center,
//         maxRadius * (i / 5),
//         Paint()
//           ..color = Colors.cyanAccent.withOpacity(0.08)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1.2,
//       );
//     }

//     final linePaint =
//         Paint()
//           ..color = Colors.purpleAccent.withOpacity(0.08)
//           ..strokeWidth = 1;
//     for (int i = 0; i < 12; i++) {
//       final angle = i * (pi / 6);
//       final dx = center.dx + maxRadius * cos(angle);
//       final dy = center.dy + maxRadius * sin(angle);
//       canvas.drawLine(center, Offset(dx, dy), linePaint);
//     }

//     final dotPaint = Paint()..color = Colors.cyanAccent.withOpacity(0.35);
//     for (int i = 0; i < 16; i++) {
//       final angle = i * (pi / 8);
//       final radius = maxRadius * 0.65;
//       final dx = center.dx + radius * cos(angle);
//       final dy = center.dy + radius * sin(angle);
//       canvas.drawCircle(Offset(dx, dy), 3.5, dotPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  final bool isSettingScreen;
  final Function(double)? onSpeedChanged;

  const SettingScreen({
    super.key,
    this.onSpeedChanged,
    this.isSettingScreen = false,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double movementSpeed = 5.0;
  double soundVolume = 7.0;
  double difficulty = 3.0;
  bool enableSound = true;
  bool enableNotifications = true;
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      movementSpeed = prefs.getDouble('movementSpeed') ?? 5.0;
      soundVolume = prefs.getDouble('soundVolume') ?? 7.0;
      difficulty = prefs.getDouble('difficulty') ?? 3.0;
      enableSound = prefs.getBool('enableSound') ?? true;
      enableNotifications = prefs.getBool('enableNotifications') ?? true;
      darkMode = prefs.getBool('darkMode') ?? true;
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('movementSpeed', movementSpeed);
    await prefs.setDouble('soundVolume', soundVolume);
    await prefs.setDouble('difficulty', difficulty);
    await prefs.setBool('enableSound', enableSound);
    await prefs.setBool('enableNotifications', enableNotifications);
    await prefs.setBool('darkMode', darkMode);
  }

  // Apply settings and notify parent
  void _applySettings() {
    _saveSettings();
    if (widget.onSpeedChanged != null) {
      widget.onSpeedChanged!(movementSpeed);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Custom background
          CustomPaint(painter: _BackgroundPainter(), size: Size.infinite),
          CustomPaint(painter: _BackgroundPainter(), size: Size.infinite),

          Center(child: buildSettingDialog()),
        ],
      ),
    );
  }

  Widget buildSettingDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.85),
              Colors.deepPurple.shade900.withOpacity(0.9),
              Colors.indigo.shade900.withOpacity(0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.cyanAccent.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 12,
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, size: 45),
              const SizedBox(height: 18),
              ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.purpleAccent],
                    ).createShader(bounds),
                child: const Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Column(
                children: [
                  _buildToggleSetting(
                    "Sound",
                    enableSound,
                    Icons.music_note,
                    (value) => setState(() => enableSound = value),
                  ),
                  _buildToggleSetting(
                    "Notifications",
                    enableNotifications,
                    Icons.notifications,
                    (value) => setState(() => enableNotifications = value),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 20),

              _buildSliderSetting(
                "Movement Speed",
                movementSpeed,
                1,
                10,
                Icons.speed,
                Colors.cyanAccent,
                false,
                (value) => setState(() => movementSpeed = value),
              ),
              const SizedBox(height: 20),
              enableSound == true
                  ? _buildSliderSetting(
                    "Sound Volume",
                    soundVolume,
                    0,
                    10,
                    Icons.volume_up,
                    Colors.pinkAccent,
                    false,
                    (value) => setState(() {
                      soundVolume = value;
                    }),
                  )
                  : GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enable the sound first"),
                        ),
                      );
                    },
                    child: _buildSliderSetting(
                      "Sound Volume",
                      soundVolume,
                      0,
                      10,
                      Icons.volume_up,
                      Colors.pinkAccent,
                      true,
                      (value) => setState(() {
                        // soundVolume = value;
                      }),
                    ),
                  ),
              const SizedBox(height: 20),
              _buildSliderSetting(
                "Difficulty Level",
                difficulty,
                1,
                5,
                Icons.leaderboard,
                Colors.orangeAccent,
                false,
                (value) => setState(() => difficulty = value),
              ),

              widget.isSettingScreen == true
                  ? SizedBox(height: 20)
                  : const SizedBox(height: 35),
              widget.isSettingScreen == true
                  ? SizedBox()
                  : Row(
                    children: [
                      Expanded(
                        child: _buildGradientButton(
                          label: 'Resume',
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00C6FF),
                              Color(0xFF0072FF),
                            ], // cyan → deep blue
                          ),
                          onTap: () {
                            Provider.of<GameState>(
                              context,
                              listen: false,
                            ).togglePause();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: _buildGradientButton(
                          label: 'Main Menu',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                          ),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainMenuScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildActionButton(
                      "CANCEL",
                      Icons.close_rounded,
                      Color(0xFFFF4E50),
                      () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12),

                  Expanded(
                    child: _buildActionButton(
                      "APPLY",
                      Icons.check_circle_rounded,
                      Color(0xFF56ab2f),
                      _applySettings,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    double min,
    double max,
    IconData icon,
    Color color,
    bool isDisable,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: CustomThumbShape(),
            overlayColor: color.withOpacity(0.2),
            activeTrackColor: color,
            inactiveTrackColor: Colors.white24,
            thumbColor: color,
            disabledActiveTrackColor: Colors.grey.shade700,
            disabledInactiveTrackColor: Colors.grey.shade800,
            disabledThumbColor: Colors.grey.shade600,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value.toStringAsFixed(1),
            onChanged: isDisable ? null : onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSetting(
    String title,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.cyanAccent,
            activeTrackColor: Colors.cyanAccent.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    Function() onTap,
  ) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Color.lerp(color, Colors.black, 0.4)!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Slider thumb
class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint =
        Paint()
          ..shader = RadialGradient(
            colors: [sliderTheme.thumbColor!, Colors.white],
          ).createShader(Rect.fromCircle(center: center, radius: 10));

    canvas.drawCircle(center, 9, paint);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }
}

// Futuristic background
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bgPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.black,
              Colors.deepPurple.shade900,
              Colors.indigo.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.75;

    for (double i = 1; i <= 5; i++) {
      canvas.drawCircle(
        center,
        maxRadius * (i / 30),
        Paint()
          ..color = Colors.cyanAccent.withOpacity(0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }

    final linePaint =
        Paint()
          ..color = Colors.purpleAccent.withOpacity(0.08)
          ..strokeWidth = 1;
    for (int i = 0; i < 12; i++) {
      final angle = i * (pi / 6);
      final dx = center.dx + maxRadius * cos(angle);
      final dy = center.dy + maxRadius * sin(angle);
      canvas.drawLine(center, Offset(dx, dy), linePaint);
    }

    final dotPaint = Paint()..color = Colors.cyanAccent.withOpacity(0.35);
    for (int i = 0; i < 16; i++) {
      final angle = i * (pi / 8);
      final radius = maxRadius * 0.65;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(dx, dy), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
