# RE1 Inventory Tracker

A real-time visual inventory overlay for **Resident Evil 1 (Biohazard)** [Classic Rebirth](https://classicrebirth.com/index.php/downloads/resident-evil-classic-rebirth/).

This tool synchronizes with the game's memory to provide an external, real-time view of your current items and resources.

📹 [Install video and showcase (English)](https://youtu.be/N_DhRtPLl0w?si=yU2KO41lDTNLRiim)
📹 [Install video and showcase (Spanish)](https://youtu.be/DiURkLnZREQ)

---

![inventory](https://github.com/user-attachments/assets/e258eebd-c816-45a8-bf3a-88fcdec27d07)

## Features

* **8-Slot Dynamic Grid**: Automatically displays item icons for all eight inventory slots
* **Smart Quantity Positioning**:
  * **Weapons**: Displays counts on the left side of the slot.
  * **Consumables**: Displays counts (ammo/ribbons) on the right side.
* **Memory-Driven Updates**: Polls the `Biohazard.exe` process to reflect inventory changes in real-time.
* Draggable window for custom placement.
* Added **IGT** for tracking **real in-game time**.
* Added **Health** overlay.
* Standard and **HD Texture Pack** modes.

## Compiling from source

* **Language**: AutoHotkey v1.1+
* **Frequency**: 250ms polling rate for low latency and minimal CPU impact.
* **Process Hooking**: 5s for autorehook in case process is closed.

## 📂 Custom Assets

The script expects an `img/` folder containing:

* `inventory.png` (GUI background)
* `rightNumber.png` (Panel to hide original UI)
* `0.png` through `112.png` (Item icons corresponding to internal IDs)
