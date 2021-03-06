#!/bin/sh
url="$(xclip -selection clipboard -o)"
music_dir="$HOME/personal/music"

alias down-yt='yt-dlp --extract-audio --audio-format best "$url" --output "%(title)s.%(ext)s"'

single_video_download() {
    info="$(yt-dlp --get-title --get-description --no-playlist "$url")"
    title="$(echo "$info" | head -1 )"

    split="Split chapters"
    one_video="Download as one video"
    if echo "$info" | grep -P "(\d{1,2}:)?\d{1,2}:\d{1,2}">/dev/null; then
        to_split_or_not_to_split="$(printf "%s\n%s" "$split" "$one_video" | menu)"
        [ -z "$to_split_or_not_to_split" ] && exit 1

        if [ "$to_split_or_not_to_split" = "$split" ]; then
            mkdir -p "$music_dir/$title"
            music_dir="$music_dir/$title"
            down-yt -P "$music_dir" --split-chapters --no-playlist
            err="$?"
        else
            down-yt -P "$music_dir" --no-playlist
            err="$?"
        fi

    else
        down-yt -P "$music_dir" --no-playlist
        err="$?"
    fi

    if [ "$err" -eq 0 ]; then
        notify-send -t 5000 "download-yt.sh" "Downloading '$title' has finished successfully."
    else
        notify-send -u critical "download-yt.sh" "Downloading '$title' failed."
        rm -rf "$music_dir/$title"
        exit 1
    fi
}

if ! command -v yt-dlp > /dev/null; then
    notify-send -t 5000 -u critical "download-yt.sh" "'yt-dlp' isn't installed."
    exit 1
fi

if echo "$url" | grep -Ei "youtube.com/channel">/dev/null; then
    notify-send -t 3000 -u critical "download-yt.sh" "Link of channel. Exiting..."
    exit 1
fi

if ! ( echo "$url" | grep -Ei "youtube.com" ); then
    notify-send -t 3000 -u critical "download-yt.sh" "Input isn't a youtube url"
    exit 1
fi

notify-send -t 2000 "download-yt.sh" "Running..."

# Playlist link
if echo "$url" | grep -Ei "(youtube.com/watch|youtu.be).*list">/dev/null; then
    full="Download full playlist"
    single="Download single video"
    choice="$(printf "%s\n%s" "$single" "$full" | menu)"

    if [ "$choice" = "$single" ]; then
        single_video_download
    elif [ "$choice" = "$full" ]; then
        dir_name="$(menu)"
        # if dir_name is empty give it a random name
        [ -z "$dir_name" ] && dir_name="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20 ; echo '')"
        mkdir -p "$music_dir/$dir_name"
        title="$(yt-dlp --get-title "$url")"

        if down-yt --yes-playlist -P "$music_dir/$dir_name"; then
            notify-send -t 5000 "download-yt.sh" "Downloading\n--\n$title\n--\nhas finished successfully."
        else
            notify-send -u critical "download-yt.sh" "Downloading playlist failed."
            rm -rf "$music_dir/$dir_name"
        fi
    fi

# Single video link
elif echo "$url" | grep -Ei "(youtube.com/watch|youtu.be)">/dev/null; then
    single_video_download
fi
