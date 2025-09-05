# Modern GUI Library 

A sleek, smooth, and modern GUI library with blur effects, animations, and full customization.

## 🔧 Features
- **Modern Design** – Clean UI with rounded corners, shadows, and smooth animations
- **Blur Background** – Glass-like blur effect using DepthOfField
- **Smooth Animations** – Uses TweenService with Back and Quint easing
- **Draggable Windows** – Click and drag the top bar to move the UI
- **Tabs & Sections** – Organize your UI into tabs and sections
- **Interactive Elements** – Buttons, toggles, sliders, dropdowns, keybinds
- **Notifications** – Modern notification system with icons and duration
- **Performance Optimized** – Minimal render step usage and efficient tweening

## 📦 Installation
1. Copy the entire script into a `ModuleScript`
2. Place it in `ReplicatedStorage` or `ServerScriptService`
3. Require it in your script:
```lua
local Library = require(game:GetService("ReplicatedStorage").ModernGUILibrary)
