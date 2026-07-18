#!/usr/bin/bash

# main processing


process() {
	ARG="$1"
	shift
	case "$ARG" in
	start)
		start "$@"
		RETVAL=$?
		;;
	stop)
		stop "$@"
		RETVAL=$?
		;;
	verify)
		if declare -f verify &> /dev/null;
		then
			verify "$@"
		else
			:
		fi
		RETVAL=$?
		;;
	*)
		echo $"Usage: $0 {start|stop|verify}"
		RETVAL=2
		;;
	esac

	exit $RETVAL
}


_usb_autosuspend() {
	value=$1
	for i in /sys/bus/usb/devices/*/power/autosuspend; do echo $value > $i; done &> /dev/null
}

enable_usb_autosuspend() {
	_usb_autosuspend 1
}

disable_usb_autosuspend() {
	_usb_autosuspend 0
}

disable_wifi_powersave() {
    for dev in $(iw dev | awk '$1=="Interface"{print $2}'); do
        iw dev "$dev" set power_save off
    done
}

enable_wifi_powersave() {
    for dev in $(iw dev | awk '$1=="Interface"{print $2}'); do
        iw dev "$dev" set power_save on
    done
}


start() {
    [ "$USB_AUTOSUSPEND" = 1 ] && enable_usb_autosuspend
    enable_wifi_powersave
    return 0
}

stop() {
    [ "$USB_AUTOSUSPEND" = 1 ] && disable_usb_autosuspend
    disable_wifi_powersave
    return 0
}

process $@
