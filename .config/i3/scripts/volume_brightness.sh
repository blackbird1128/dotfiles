#!/usr/bin/env bash
# Original source: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

bar_color="#7f7fff"
volume_step=1
brightness_step=5
max_volume=100
max_brightness=$(brightnessctl m)

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# --- Volume handling -------------------------------------------------------

get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

get_volume_icon() {
    local volume mute
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" = "yes" ]; then
        volume_icon=" "
    elif [ "$volume" -lt 50 ]; then
        volume_icon=" "
    else
        volume_icon=" "
    fi
}

show_volume_notif() {
    local volume
    volume=$(get_volume)
    get_volume_icon
    dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal \
        "$volume_icon $volume%" -h int:value:"$volume" -h string:hlcolor:"$bar_color"
}

# --- Brightness handling ---------------------------------------------------

get_brightness() {
    brightnessctl g
}

get_brightness_icon() {
    brightness_icon=""
}

show_brightness_notif() {
    local brightness percent
    brightness=$(get_brightness)
    get_brightness_icon
    percent=$(( brightness * 100 / max_brightness ))
    dunstify -t 1000 -r 2594 -u normal \
        "$brightness_icon ${percent}%" -h int:value:"$percent" -h string:hlcolor:"$bar_color"
}

# --- Main -----------------------------------------------------------------

case "$1" in
    volume_up)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        volume=$(get_volume)
        if [ $((volume + volume_step)) -gt $max_volume ]; then
            pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +${volume_step}%
        fi
        show_volume_notif
        ;;
    volume_down)
        pactl set-sink-volume @DEFAULT_SINK@ -${volume_step}%
        show_volume_notif
        ;;
    volume_mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        show_volume_notif
        ;;
    brightness_up)
        brightnessctl set +${brightness_step}%
        show_brightness_notif
        ;;
    brightness_down)
        brightnessctl set ${brightness_step}-%
        show_brightness_notif
        ;;
    *)
        echo "Usage: $0 {volume_up|volume_down|volume_mute|brightness_up|brightness_down}"
        exit 1
        ;;
esac
