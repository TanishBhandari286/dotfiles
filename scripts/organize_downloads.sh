
#!/bin/zsh

DOWNLOADS="$HOME/Downloads"

for file in $DOWNLOADS/*; do
    if [[ -f "$file" ]]; then
        ext="${file##*.}"

        # Skip if no extension
        if [[ "$ext" == "$file" ]]; then
            continue
        fi

        ext="${ext:l}"  # lowercase in zsh

        mkdir -p "$DOWNLOADS/$ext"
        mv "$file" "$DOWNLOADS/$ext/"
        echo "Moved ${file:t} → $ext/"
    fi
done

echo "Downloads folder organized!"
