# Mirror World Runner

**A fast-paced endless runner built with Flutter & Flame**

Live demo: [https://mirror-world-runner-g8nw2osfu.vercel.app/](https://mirror-world-runner-g8nw2osfu.vercel.app/)

---

## Overview

Mirror World Runner is an endless runner where you control **two characters at once** — one in the real world and one in the mirrored world. Dodge obstacles, collect power-ups, and survive as long as possible while managing both worlds simultaneously.

Key features:

* 🌟 Control both characters at the same time
* 🎯 Synchronized but mirrored obstacle challenges
* ⚡ Multiple power-ups that change gameplay
* 👆 Drag anywhere to move both players simultaneously
* 🎮 Arrow keys for precise control (desktop)
* ❤️ Simple, addictive survival gameplay

This project is implemented using **Flutter** and the **Flame game engine**, and is built to run on **Flutter Web** and as a **mobile Flutter app**.

---

## Demo

Play the web build here:

**[https://mirror-world-runner-g8nw2osfu.vercel.app/](https://mirror-world-runner-g8nw2osfu.vercel.app/)**

(Recommended: desktop for arrow-key control, mobile/tablet for touch/drag controls.)

"https://github.com/PHarshilLadila/mirror-world-runner/blob/main/assets/images/demo/setting_screen.png"

---

## Gameplay / Controls

* **Drag (touch / mouse)** anywhere on the screen to move both characters left/right.
* **Arrow keys** (←/→) provide precise left/right movement on desktop.
* Avoid obstacles in each world — collisions on either side can end the run.
* Collect power-ups to gain temporary advantages (invincibility, score multipliers, speed boosts, etc.).

---

## Requirements

* Flutter (stable channel) — tested with recent stable releases
* Dart SDK (bundled with Flutter)
* A modern browser for web builds (Chrome, Edge, Firefox)
* For mobile: Android SDK / Xcode (to build and run on devices)

Check your local `flutter --version` and update Flutter if needed.

---

## How to run (local)

### Web

1. Clone the repository.
2. Ensure Flutter is installed and web support is enabled (`flutter doctor`).
3. From the project root run:

```bash
flutter run -d chrome
```

This starts a local web server and opens the game in Chrome.

### Mobile (Android / iOS)

1. Connect your device or start an emulator/simulator.
2. From the project root run:

```bash
flutter run
```

The app will build and install to the connected device/emulator.

> Tip: Use `flutter build web` to create an optimized web bundle for deployment.

---

## Configuration & Customization

* Assets: Replace images/audio inside `assets/` and update paths in `pubspec.yaml`.
* Difficulty & tuning: Gameplay parameters (obstacle spawn rate, player speed, etc.) are centralized in the game's configuration files — tweak them to adjust difficulty.
* Controls: Input handling is modular; you can add swipe gestures, virtual buttons, or gamepad support if desired.

---

## Recommended Packages

(These are commonly used in Flame + Flutter games — verify exact versions in `pubspec.yaml`)

* `flame` — game engine
* `flutter` — UI framework
* `shared_preferences` — save high scores and settings
* `audioplayers` or `flame_audio` — sound effects & music

---

## Performance Tips

* Use sprite atlases and compressed audio to reduce memory and load times.
* Limit per-frame object allocations; reuse components where possible.
* Profile in debug and release modes (`flutter run --profile`, `flutter build apk --release`).

---

## License

Choose a license for your project (e.g., MIT, Apache 2.0). If you don't want an open-source license yet, state “All rights reserved.”

---

## Contact

If you want help, feedback, or want to show me your improvements, open an issue or create a pull request in the repository.

---

Thanks for checking out **Mirror World Runner** — have fun building and playing! 🚀
