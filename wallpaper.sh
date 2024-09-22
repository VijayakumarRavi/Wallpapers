#!/bin/bash

# Default folder for images
DEFAULT_DIR=~/Developer/Github/Wallpapers
IMAGE_DIR="${1:-$DEFAULT_DIR}"

# Supported image formats
IMAGE_EXTENSIONS="jpg png"

# Get the operating system name
OS_NAME=$(uname -s)

# Function to display error and exit
function error_exit {
    echo "Error: $1" >&2
    exit 1
}

# Check if the folder exists
if [[ ! -d "$IMAGE_DIR" ]]; then
    error_exit "The directory '$IMAGE_DIR' does not exist."
fi

# Find jpg and png images in the folder
IMAGES=($(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort))

# Check if any images were found
if [[ ${#IMAGES[@]} -eq 0 ]]; then
    error_exit "No jpg or png images found in '$IMAGE_DIR'."
fi

# Function to set the wallpaper
function set_wallpaper_macos {
    local image="$1"
    # Use AppleScript to set the wallpaper
    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$image\""
    killall Finder
    echo "Wallpaper set to $image."
}

function set_wallpaper_linux {
    local image="$1"
    # Use feh to set the wallpaper
    feh --no-fehbg --bg-fill "$image"
    echo "Wallpaper set to $image."
}

# Main workflow
function set_wallpaper {
    echo "Opening image selector with preview..."

    # Select an image using fzf with Kitty preview
    selected_image=$(printf "%s\n" "${IMAGES[@]}" | fzf --preview='kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}')

    if [[ -z "$selected_image" ]]; then
        error_exit "No image selected."
    fi

    echo "Selected image: $selected_image"

    # Confirm the user wants to set it as wallpaper
    read -p "Do you want to set this image as your wallpaper? (y/n, default is y): " confirm
    confirm=${confirm:-y}  # Default to 'y' if no input
    
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        if [[ "$OS_NAME" == "Darwin" ]]; then
            set_wallpaper_macos "$selected_image"
        elif [[ "$OS_NAME" == "Linux" ]]; then
            set_wallpaper_linux "$selected_image"
        else
            error_exit "Unsupported operating system: $OS_NAME"
        fi
        echo "Wallpaper set to $(basename "$selected_image")"
    else
        echo "Wallpaper not changed."
    fi
}

# Run the set_wallpaper function
set_wallpaper
