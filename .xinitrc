xsetroot -cursor_name left_ptr &

export _JAVA_AWT_WM_NONREPARENTING=1 
export QT_QPA_PLATFORMTHEME=qt5ct

sxhkd &
exec bspwm
#exec awesome
