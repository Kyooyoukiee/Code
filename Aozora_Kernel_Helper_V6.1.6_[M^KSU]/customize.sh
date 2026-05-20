# Info
device=$(getprop ro.product.system.device)
model=$(getprop ro.product.system.model)
soc=$(getprop ro.product.board)
modver=$(grep_prop version "$MODPATH"/module.prop)
moddesc=$(grep_prop description "$MODPATH"/module.prop)
ui_print "- Version: $modver"
ui_print "- $moddesc"
ui_print " "

# Determine which version information to display
if [ "$KSU" == true ]; then
  ui_print "- KSU Version: $KSU_VER"
  ui_print "- KSU Version Code: $KSU_VER_CODE"
  ui_print "- KSU Kernel Version Code: $KSU_KERNEL_VER_CODE"
  sleep 0.2
else
  ui_print "- MagiskVersion=$MAGISK_VER";
  ui_print "- MagiskVersionCode=$MAGISK_VER_CODE";
  sleep 0.2
fi

# Running Installing Script
ui_print "Installing..."
ui_print ""
ui_print "Installing for device: $device"
ui_print "Model: $model" 
ui_print "SoC: $soc"
ui_print ""

# Set permissions
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755 u:object_r:system_file:s0

ui_print " "
ui_print "- Done 🥰"
ui_print " "
ui_print "- Please reboot your device!"
ui_print " "