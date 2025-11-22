=====================================================
// C4CHO0RR0K9'S WORKFLOW INITIATED //
=====================================================
[ USER: C4CHO0RR0K9 ]
[ SYSTEM: Ubuntu 22.04 (X.Org) ]
[ MODULES: Tiling Engine | Gesture Control ]
-----------------------------------------------------
STATUS: PRODUCTIVITY ENGAGED
=====================================================

# Ubuntu-Xorg-Productivity-Boost

This project documents the installation, configuration, and troubleshooting for creating an automated workflow environment on **Ubuntu 22.04 (GNOME on X.Org)**, implementing **Automatic Tiling** for four terminals (Or any window. I used terminals as an example, but you can use and open any app or web application.) and advanced **Custom Trackpad Gestures**.


## 1. System Requirements and Dependency Installation

### 1.1 Critical Requirements

1.  **Graphics Server:** You **must use X.Org** (not Wayland). Select "Ubuntu on Xorg" at the login screen.
2.  **Display Resolution:** The Tiling script is calibrated for a **1920x1080** display.

### 1.2 Install Dependencies

Install the required packages for window management (`wmctrl`, `xdotool`) and input handling (`libinput-tools`).

```bash
sudo apt update
sudo apt install wmctrl xdotool git libinput-tools
```

## 2. Configuration: Custom Trackpad Gestures

### 2.1 Installation and Permissions

#### 2.1.1 Install libinput-gestures

```bash
git clone [https://github.com/bulletmark/libinput-gestures.git](https://github.com/bulletmark/libinput-gestures.git)
cd libinput-gestures
sudo ./libinput-gestures-setup install
```
#### 2.1.2 Assign Input Group Permission: This step is MANDATORY for the program to read raw trackpad events.

```bash
sudo adduser $USER input
```
##### 2.1.3 REBOOT

```bash
shutdown -r now
```
### 2.2 Create configuration File: "libinput-gestures.conf" with the following rules

```bash
# ----------------------------------------------------------------------
# libinput-gestures: Custom Gesture Configuration for GNOME/X.Org
# ----------------------------------------------------------------------

# THREE FINGER GESTURES (Workspace, Overview)
# ======================================================================

# Up: Show all windows (Activities Overview)
gesture swipe up 3 xdotool key super

# Down: Close Activities Overview / Hide windows
gesture swipe down 3 xdotool key Escape

# Workspace Switching (NATURAL MOVEMENT)
# Swipe Left -> Move to Left Workspace
gesture swipe left 3 xdotool key super+alt+Left

# Swipe Right -> Move to Right Workspace
gesture swipe right 3 xdotool key super+alt+Right


# TWO FINGER GESTURES (Browser Navigation)
# ======================================================================

# Browser: Go to Previous Page (Back)
gesture swipe left 2 xdotool key alt+Left

# Browser: Go to Next Page (Forward)
gesture swipe right 2 xdotool key alt+Right
```

### 2.3 Aply Configuration and VM Workaround

##### 2.3.1 Copy Rules to system Location (To work more easy)

```bash
cp config/libinput-gestures.conf ~/.config/libinput-gestures.con
```
#### 2.3.2 Stop and Force Execution (VM Fix) This command sequence solve the "Failes to start" error in VirtualBox Environments

```bash
libinput-gestures-setup stop
libinput-gestures --device /dev/input/by-id/usb-VirtualBox_USB_Tablet-event-mouse
```

## 3. Configuration: Automatic Tiling Script

### 3.1 Crate Script File: "~scripts/start_apps.sh"

Create the file "~Scripts/apps_start.sh" with the following code. It is calibrated for 1920x1080 resolution.

```bash
#!/bin/bash

# --- DIMENSION SETTINGS (EXACT ADJUSTMENT for 1920x1080) ---
WINDOW_WIDTH=960
WINDOW_HEIGHT=540 

POS_X_LEFT=0
POS_Y_TOP=0
POS_X_RIGHT=960      # X position (right column start)
POS_Y_BOTTOM=540     # Y position (bottom row start)


# --- 1. Open FOUR Terminal Windows ---
setsid gnome-terminal &
sleep 0.5 
setsid gnome-terminal &
sleep 0.5
setsid gnome-terminal &
sleep 0.5
setsid gnome-terminal &

# Wait time for windows to load (critical for wmctrl to find them).
sleep 4 

ALL_IDS=$(wmctrl -lx)

# --- 2. Get the IDs of the 4 Terminal Windows ---
TERMINAL_IDS=$(echo "$ALL_IDS" | grep "gnome-terminal-server.Gnome-terminal")

# Assign IDs sequentially (assuming these are the 4 newest windows)
TERM1_ID=$(echo "$TERMINAL_IDS" | tail -n 4 | head -n 1 | awk '{print $1}')
TERM2_ID=$(echo "$TERMINAL_IDS" | tail -n 3 | head -n 1 | awk '{print $1}')
TERM3_ID=$(echo "$TERMINAL_IDS" | tail -n 2 | head -n 1 | awk '{print $1}')
TERM4_ID=$(echo "$TERMINAL_IDS" | tail -n 1 | awk '{print $1}')


# --- 3. Arrange Windows (Absolute Positioning) ---
# wmctrl format: -e <G>,<x>,<y>,<width>,<height>

# 1. Terminal 1: Top Left
wmctrl -i -r $TERM1_ID -b remove,maximized_vert,maximized_horz
wmctrl -i -r $TERM1_ID -e 0,$POS_X_LEFT,$POS_Y_TOP,$WINDOW_WIDTH,$WINDOW_HEIGHT

# 2. Terminal 2: Top Right
wmctrl -i -r $TERM2_ID -b remove,maximized_vert,maximized_horz
wmctrl -i -r $TERM2_ID -e 0,$POS_X_RIGHT,$POS_Y_TOP,$WINDOW_WIDTH,$WINDOW_HEIGHT 

# 3. Terminal 3: Bottom Left
wmctrl -i -r $TERM3_ID -b remove,maximized_vert,maximized_horz
wmctrl -i -r $TERM3_ID -e 0,$POS_X_LEFT,$POS_Y_BOTTOM,$WINDOW_WIDTH,$WINDOW_HEIGHT

# 4. Terminal 4: Bottom Right
wmctrl -i -r $TERM4_ID -b remove,maximized_vert,maximized_horz
wmctrl -i -r $TERM4_ID -e 0,$POS_X_RIGHT,$POS_Y_BOTTOM,$WINDOW_WIDTH,$WINDOW_HEIGHT
```
### 3.2 Execution Permissions and shortcut Setup

#### 3.2.1 Apply execution permission (+x): This is the fix for the "Permission denied" error.

```bash
chmod +x start_apps.sh
```
#### 3.2.2 Create Simple cody (Optional): Copy the script to your home directory ~

```bash
cp scripts/start_apps.sh
```
#### 3.2.3 Keyboard Shortcut Setup: Go to setting > Keyboard > HeyboardShortcuts>Custom Shortcuts
- Command (Recommended):  Use the Obsolute path
(/home/your_username/start_apps.sh)
