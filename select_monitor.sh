#!/bin/sh

OPTION=`kdialog --radiolist "Choose monitor configuration" 1 "HDMI" on 2 "LVDS" off 3 "LVDS->HDMI" off 4 "HDMI->LVDS" off`

echo 'selected option '$OPTION 
case $OPTION in
'1')
    	xrandr --output HDMI-0 --auto && xrandr --output LVDS-0 --off    
    ;;
'2')
        xrandr --output LVDS-0 --auto && xrandr --output HDMI-0 --off
    ;;
'3')
    	xrandr --auto && xrandr --output LVDS-0 --auto --left-of HDMI-0;
	;;
'4')
    	xrandr --auto && xrandr --output LVDS-0 --auto --right-of HDMI-0;
    ;;
*)
    	echo "Nothing selected"
	;;
esac