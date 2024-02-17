#!/bin/bash

# Function to search for webcam drivers
search_drivers() {
    # Search for webcam drivers
    drivers=$(lsmod | grep -iE 'uvc|videodev')

    # Check if any drivers were found
    if [ -n "$drivers" ]; then
        echo "Webcam drivers found:"
        echo "$drivers"
    else
        echo "No webcam drivers found."
    fi
}

# Function to activate or deactivate webcam drivers
activate_deactivate_drivers() {
    choice=$1

    # Check if the user's choice is "e" to enable or "d" to disable
    if [ "$choice" == "e" ]; then
        # Activate webcam drivers
        sudo modprobe -a $(lsmod | grep -iE 'uvc|videodev' | awk '{print $1}') 2>/dev/null
    elif [ "$choice" == "d" ]; then
        # Deactivate webcam drivers
        sudo rmmod $(lsmod | grep -iE 'uvc|videodev' | awk '{print $1}') 2>/dev/null
    else
        # Display an error message if the user's choice is invalid
        echo "Invalid choice. Type 'e' to enable or 'd' to disable."
        exit 1
    fi

    # Check if there was any error while activating or deactivating the drivers
    if [ $? -eq 0 ]; then
        echo "Webcam drivers $([ "$choice" == "e" ] && echo "enabled" || echo "disabled")."
    else
        echo "No webcam drivers found."
    fi
}

# Ask the user to type "e" to enable or "d" to disable webcam drivers
read -p "Type 'e' to enable or 'd' to disable webcam drivers: " choice

# Call the function to activate or deactivate webcam drivers
activate_deactivate_drivers $choice
