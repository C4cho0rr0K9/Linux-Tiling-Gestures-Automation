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
