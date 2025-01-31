#!/bin/bash

# Define a file to store settings
CONFIG_FILE="$HOME/.sdwebui_config"

#!/bin/bash
if [ ! -d "myenv" ]; then
  echo "Sanal ortam oluşturuluyor..."
  python3.11 -m venv myenv
else
  echo "Sanal ortam zaten mevcut."
fi
source myenv/bin/activate


# Help
help_message() {
    echo "Kullanım:"
    echo "  sdwebui            - Runs Stable Diffusion WebUI."
    echo "  sdwebui -h         - Displays the help message."
    echo "  sdwebui -set       - Sets a new file directory."
    echo "  sdwebui -r, -remove - Clears the selected file directory."
}

# Konfigürasyon dosyasını kontrol et
check_config() {
    if [[ ! -f $CONFIG_FILE ]]; then
        echo "You need to specify the directory where Stable Diffusion WebUI is installed:"
        read -rp "Directory path: " dir
        echo "$dir" > "$CONFIG_FILE"
    fi
    DIRECTORY=$(cat "$CONFIG_FILE")
}

# Dosya dizinini güncelle
set_directory() {
    echo "Specify the new file directory:"
    read -rp "Directory path: " dir
    echo "$dir" > "$CONFIG_FILE"
    echo "New directory has been set: $dir"
}

# Dosya dizinini kaldır
remove_directory() {
    if [[ -f $CONFIG_FILE ]]; then
        rm "$CONFIG_FILE"
        echo "File directory has been cleared. It will be prompted again on first use."
    else
        echo "No directory is currently set."
    fi
}

# Stable Diffusion WebUI'yi başlat
run_sdwebui() {
    if [[ -z "$DIRECTORY" || ! -d "$DIRECTORY" ]]; then
        echo "A valid directory could not be found. Please set a directory using 'sdwebui -set'."
        exit 1
    fi
    cd "$DIRECTORY" || exit
    sh webui.sh --lowvram --always-batch-cond-uncond
}

# Komutları kontrol et
case "$1" in
    -h)
        help_message
        ;;
    -set)
        set_directory
        ;;
    -r|-remove)
        remove_directory
        ;;
    "")
        check_config
        run_sdwebui
        ;;
    *)
        echo "Incorrect command. You can type 'sdwebui -h' for help."
        ;;
esac
