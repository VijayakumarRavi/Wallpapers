#!/usr/bin/env bash
set -o errexit
set -o nounset
set -euo pipefail

echo "Choose a wallpaper from the following options:"
# Default folder for images
DEFAULT_DIR="$HOME/Pictures/Wallpapers/images"
if [[ -n "${1-}" ]]; then
  IMAGE_DIR="$1"
  echo "Using directory $IMAGE_DIR"
else
  IMAGE_DIR="$DEFAULT_DIR"
fi

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
mapfile -t IMAGES < <(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

# Check if any images were found
if [ ${#IMAGES[@]} -eq 0 ]; then
    error_exit "No jpg or png images found in '$IMAGE_DIR'."
fi

# Function to set the wallpaper
function set_wallpaper_macos {
    local image="$1"
    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$image\""
    killall Finder
    echo "Wallpaper set to $image."
}

function set_wallpaper_linux {
    local image="$1"
    feh --no-fehbg --bg-fill "$image"
    echo "Wallpaper set to $image."
}

# Main workflow
function set_wallpaper {
    # Use fixed dimensions for the preview, can be overridden by environment variables
    # shellcheck disable=SC2016
    selected_image=$(printf '%s\n' "${IMAGES[@]}" | awk -v dir="$IMAGE_DIR" '{print $0, substr($0, length(dir) + 2)}' | fzf --with-nth=2 --preview='kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {1}')
    selected_image=${selected_image%% *}
    kitty icat --clear
    if [[ -z "$selected_image" ]]; then
        error_exit "No image selected."
    fi
    echo "Selected image: $selected_image"
    read -r -p "Do you want to set this image as your wallpaper? [y/n, default is y]: " confirm
    confirm=${confirm:-y}  # Default to 'y' if no input
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
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

