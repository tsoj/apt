#!/bin/bash

# Function to play sound using available audio players
play_sound() {
    local sound_file="$1"

    if command -v gst-launch-1.0 >/dev/null 2>&1; then
        gst-launch-1.0 -q playbin uri=file://"$sound_file" >/dev/null 2>&1 &
    elif command -v paplay >/dev/null 2>&1; then
        paplay "$sound_file" >/dev/null 2>&1
    elif command -v aplay >/dev/null 2>&1; then
        aplay -q -l 0 "$sound_file" >/dev/null 2>&1 &
    else
        return 1
    fi

    echo $!  # Return the process ID
}

# Function to cleanup sound process
cleanup_sound() {
    local pid=$1
    if [ -n "$pid" ]; then
        kill $pid 2>/dev/null
        wait $pid 2>/dev/null
    fi
}

# Function to check if we're in an interactive terminal
is_interactive() {
    [ -t 0 ] && ps -o comm= -p $PPID | grep -qE '^(bash|zsh|fish)$'
}

# Function to handle apt execution with sound
apt_with_sound() {
    if is_interactive; then
        # Play the sound file in the background
        SOUND_PID=$(play_sound "$HOME/.local/share/sounds/apt-sound.wav")
        
        # Setup trap to clean up sound on script exit or interrupt
        trap "cleanup_sound $SOUND_PID; exit" INT TERM EXIT
        
        # Run the actual apt command with all arguments
        command apt "$@"
        APT_EXIT=$?
        
        # Remove the trap and cleanup
        trap - INT TERM EXIT
        cleanup_sound $SOUND_PID
        
        return $APT_EXIT
    else
        # If not interactive, just run apt normally
        command apt "$@"
    fi
}

# Function to handle sudo apt with sound
sudo_wrapper() {
    if [ "$1" = "apt" ] && is_interactive; then
        # Play the sound file in the background
        SOUND_PID=$(play_sound "$HOME/.local/share/sounds/apt-sound.wav")
        
        # Setup trap to clean up sound on script exit or interrupt
        trap "cleanup_sound $SOUND_PID; exit" INT TERM EXIT
        
        # Run the actual sudo command with all arguments
        command sudo "$@"
        SUDO_EXIT=$?
        
        # Remove the trap and cleanup
        trap - INT TERM EXIT
        cleanup_sound $SOUND_PID
        
        return $SUDO_EXIT
    else
        # If not apt or not interactive, just run sudo normally
        command sudo "$@"
    fi
}

# Create aliases
alias apt='apt_with_sound'
alias sudo='sudo_wrapper'
