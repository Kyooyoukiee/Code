#!/sbin/sh

# Import Fstab
#. /tmp/anykernel/tools/fstab.sh;

# Import Remover
. /tmp/anykernel/tools/remover.sh;

patch_cmdline "skip_override" "";

install_td=""
install_cpu=""
install_dhz=""
install_tm=""
install_ac=""
patch_build=0
install_init=0
vhz=60
ceknvt=0

#Check D8G DIR
D8G_DIR=/data/media/0/d8g
if [ ! -d $D8G_DIR ]; then
	mkdir -p $D8G_DIR;
fi
if [ ! -d $D8G_DIR/pubg ]; then
	mkdir -p $D8G_DIR/pubg;
fi
if [ ! -f /proc/nvt_fw_version ]; then
	ceknvt=1
fi
cekdevice=$(getprop ro.product.device 2>/dev/null);
cekproduct=$(getprop ro.build.product 2>/dev/null);
cekvendordevice=$(getprop ro.product.vendor.device 2>/dev/null);
cekvendorproduct=$(getprop ro.vendor.product.device 2>/dev/null);
for cekdevicename in $cekdevice $cekproduct $cekvendordevice $cekvendorproduct; do
	cekdevices=$cekdevicename
	break 1;
done;

# Clear
ui_print "";
ui_print "";

keytest() {
  ui_print "   Press a Vol Key..."
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > /tmp/anykernel/events) || return 1
  return 0
}

chooseport() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while (true); do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > /tmp/anykernel/events
    if (`cat /tmp/anykernel/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat /tmp/anykernel/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $bin/keycheck
  $bin/keycheck
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    abort "   Vol key not detected!"
  fi
}

if keytest; then
  FUNCTION=chooseport
else
  FUNCTION=chooseportold
  ui_print "   Press Vol Up Again..."
  $FUNCTION "UP"
  ui_print "   Press Vol Down..."
  $FUNCTION "DOWN"
fi

# Install Kernel

# Clear
ui_print " ";
ui_print " ";

if [ "$cekdevices" == "beryllium" ]; then
	detectdevice=1
	deviceset=0
	install_dv="  -> Device : Poco F1"
elif [ "$cekdevices" == "dipper" ]; then
	detectdevice=1
	deviceset=1
	install_dv="  -> Device : Mi 8"
elif [ "$cekdevices" == "polaris" ]; then
	detectdevice=1
	deviceset=1
	install_dv="  -> Device : Mi MIX 2S"
elif [ "$cekdevices" == "equuleus" ]; then
	detectdevice=1
	deviceset=1
	install_dv="  -> Device : Mi 8 Pro"
elif [ "$cekdevices" == "perseus" ]; then
	detectdevice=1
	deviceset=1
	install_dv="  -> Device : Mi MIX 3"
elif [ "$cekdevices" == "ursa" ]; then
	detectdevice=1
	deviceset=1
	install_dv="  -> Device : Mi 8 Explorer"
else
	detectdevice=0
fi

if [ $detectdevice = 0 ]; then
	ui_print " "
	ui_print "Choose your device?"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes!!... Poco"
	ui_print "   No!!... Mi 8 | Pro | Explorer - Mi MIX 2S | 3"
	if $FUNCTION; then
		deviceset=0
		ui_print " "
		ui_print "Device : POCO Selected"
		install_dv="  -> Device : POCO"
	else
		deviceset=1
		ui_print " "
		ui_print "Device : Mi 8 | Pro | Explorer - Mi MIX 2S | 3 Selected"
		install_dv="  -> Device : Mi 8 | Pro | Explorer - Mi MIX 2S | 3"
	fi
fi

# Choose DFE
ui_print " "
ui_print "Install DFE ?"
ui_print "   Vol+ = Yes, Vol- = No"
ui_print "   Yes!!... Install DFE"
ui_print "   No!!... Skip Install DFE"
ui_print " "
if $FUNCTION; then
	# Choose DFE
	ui_print " "
	ui_print "Install DFE with system_ext ?"
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print "   Yes!!... Install with system_ext"
	ui_print "   No!!... Install no system_ext"
	ui_print " "
	if $FUNCTION; then
		ui_print "-> Install DFE with system_ext Selected.."
		cp $home/kernel/dfe/fstab.qcom $home/ramdisk/fstab.qcom
	else
		ui_print "-> Install DFE no system_ext Selected.."
		cp $home/kernel/dfe/fstab_nse.qcom $home/ramdisk/fstab.qcom
	fi
	. /tmp/anykernel/tools/fstab.sh;
else
	ui_print "-> Skip Install DFE Selected.."
fi

# Choose Permissive or Enforcing
ui_print " "
ui_print "Choose Default System.."
ui_print " "
ui_print "System Ext Or Non System Ext ?"
ui_print " "
ui_print "   Vol+ = Yes, Vol- = No"
ui_print ""
ui_print "   Yes.. With system_ext"
ui_print "   No!!... Non system_ext"
ui_print " "

if $FUNCTION; then
	ui_print "-> With system_ext Selected.."
	install_se="  -> system_ext..."
	dtb_se=kernel/dtbs/se
	dtb_se_dip=kernel/dipper/se
	se_main=1;
else
	ui_print "-> Non system_ext Selected.."
	install_se="  -> non system_ext..."
	dtb_se=kernel/dtbs/nse
	dtb_se_dip=kernel/dipper/nse
	se_main=0;
fi

set75(){
if [ -f $home/$dtb_se/$doc_mode/75/beryllium-mp-v2.1.dtb ]; then
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print "   Yes!!... Install FPS 75hz"
	if [ -f $home/$dtb_se/$doc_mode/81/beryllium-mp-v2.1.dtb ]; then
		ui_print "   No!!... Install Stock FPS - 81hz"
	elif [ -f $home/$dtb_se/$doc_mode/90/beryllium-mp-v2.1.dtb ]; then
		ui_print "   No!!... Install Stock FPS - 90hz"
	else
		ui_print "   No!!... Install Stock FPS - 60hz"
	fi
	ui_print " "
	if $FUNCTION; then
		# 75
		ui_print "-> Display 75hz Selected.."
		install_dhz="  -> Display 75hz...";
		vhz=75
	else
		if [ -f $home/$dtb_se/$doc_mode/81/beryllium-mp-v2.1.dtb ]; then
			set81
		else
			set90
		fi
	fi
else
	set90
fi;
}

set81(){
if [ -f $home/$dtb_se/$doc_mode/81/beryllium-mp-v2.1.dtb ]; then
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print "   Yes!!... Install FPS 81hz"
	if [ -f $home/$dtb_se/$doc_mode/90/beryllium-mp-v2.1.dtb ]; then
		ui_print "   No!!... Install Stock FPS - 90hz"
	else
		ui_print "   No!!... Install Stock FPS - 60hz"
	fi
	ui_print " "
	if $FUNCTION; then
		# 81
		ui_print "-> Display 81hz Selected.."
		install_dhz="  -> Display 81hz...";
		vhz=81
	else
		set90
	fi
else
	set90
fi;
}

set90(){
if [ -f $home/$dtb_se/$doc_mode/90/beryllium-mp-v2.1.dtb ]; then
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print "   Yes!!... Install FPS 90hz"
	ui_print "   No!!... Install Stock FPS - 60hz"
	ui_print " "
	if $FUNCTION; then
	# 90
		ui_print "-> Display 90hz Selected.."
		install_dhz="  -> Display 90hz...";
		vhz=90
	else
		ui_print "-> Display 60hz Selected.."
		install_dhz="  -> Display 60hz...";
		vhz=60
	fi
else
	ui_print "-> Display 60hz Selected.."
	install_dhz="  -> Display 60hz...";
	vhz=60
fi;
}

select_ocd(){
	if [ $deviceset = 1 ]; then
		#ui_print "-> Display 60hz Selected.."
		install_dhz="  -> Display 60hz...";
		#if [ -f $compressed_image ]; then
		# Concatenate all of the dtbs to the kernel
		vhz=60
		#fi
	else
		# Choose dts
		ui_print " "
		ui_print "Choose your favorite display hz?"
		ui_print " "
		ui_print "Jangan dipaksa, gunakan semampu device kalian"
		ui_print " "
		ui_print "   Vol+ = Yes, Vol- = No"
		ui_print ""
		ui_print "   Yes!!... Install FPS 60hz"
		ui_print "   No!!... Choose again"
		ui_print " "

		if $FUNCTION; then
			ui_print "-> Display 60hz Selected.."
			install_dhz="  -> Display 60hz...";
			#if [ -f $compressed_image ]; then
			# Concatenate all of the dtbs to the kernel
			vhz=60
			#fi
		else
			ui_print "   Vol+ = Yes, Vol- = No"
			ui_print "   Yes!!... Install FPS 61hz"
			ui_print "   No!!... Choose again"
			ui_print " "
			if $FUNCTION; then
				# 61hz
				ui_print "-> Display 61hz Selected.."
				install_dhz="  -> Display 61hz...";
				#if [ -f $compressed_image ]; then
				# Concatenate all of the dtbs to the kernel
				vhz=61
				#fi
			else
				ui_print "   Vol+ = Yes, Vol- = No"
				ui_print "   Yes!!... Install FPS 65hz"
				ui_print "   No!!... Choose again"
				ui_print " "
				if $FUNCTION; then
					# 65hz
					ui_print "-> Display 65hz Selected.."
					install_dhz="  -> Display 65hz...";
					#if [ -f $compressed_image ]; then
					# Concatenate all of the dtbs to the kernel
					vhz=65
					#fi
				else
					ui_print "   Vol+ = Yes, Vol- = No"
					ui_print "   Yes!!... Install FPS 66hz"
					ui_print "   No!!... Choose again"
					ui_print " "
					if $FUNCTION; then
						# 66hz
						ui_print "-> Display 66hz Selected.."
						install_dhz="  -> Display 66hz...";
						#if [ -f $compressed_image ]; then
						# Concatenate all of the dtbs to the kernel
						vhz=66
						#fi
					else
						ui_print "   Vol+ = Yes, Vol- = No"
						ui_print "   Yes!!... Install FPS 67hz"
						ui_print "   No!!... Choose again"
						ui_print " "
						if $FUNCTION; then
							# 67hz
							ui_print "-> Display 67hz Selected.."
							install_dhz="  -> Display 67hz...";
							#if [ -f $compressed_image ]; then
								# Concatenate all of the dtbs to the kernel
							vhz=67
							#fi
						else
							ui_print "   Vol+ = Yes, Vol- = No"
							ui_print "   Yes!!... Install FPS 68hz"
							ui_print "   No!!... Choose again"
							ui_print " "
							if $FUNCTION; then
								# 68hz
								ui_print "-> Display 68hz Selected.."
								install_dhz="  -> Display 68hz...";
							#	if [ -f $compressed_image ]; then
								# Concatenate all of the dtbs to the kernel
								vhz=68
								#fi
							else
								ui_print "   Vol+ = Yes, Vol- = No"
								ui_print "   Yes!!... Install FPS 69hz"
								ui_print "   No!!... Choose again"
								ui_print " "
								if $FUNCTION; then
									# 69hz
									ui_print "-> Display 69hz Selected.."
									install_dhz="  -> Display 69hz...";
									#if [ -f $compressed_image ]; then
										# Concatenate all of the dtbs to the kernel
									vhz=69
									#fi
								else
									ui_print "   Vol+ = Yes, Vol- = No"
									ui_print "   Yes!!... Install FPS 70hz"
									ui_print "   No!!... Choose again"
									ui_print " "
									if $FUNCTION; then
										# 70hz
										ui_print "-> Display 70hz Selected.."
										install_dhz="  -> Display 70hz...";
										#if [ -f $compressed_image ]; then
											# Concatenate all of the dtbs to the kernel
										vhz=70
										#fi
									else
										ui_print "   Vol+ = Yes, Vol- = No"
										ui_print "   Yes!!... Install FPS 71hz"
										if [ -f $home/$dtb_se/$doc_mode/75/beryllium-mp-v2.1.dtb ]; then
											ui_print "   No!!... Install Stock FPS - 75hz"
										elif [ -f $home/$dtb_se/$doc_mode/81/beryllium-mp-v2.1.dtb ]; then
											ui_print "   No!!... Install Stock FPS - 81hz"
										elif [ -f $home/$dtb_se/$doc_mode/90/beryllium-mp-v2.1.dtb ]; then
											ui_print "   No!!... Install Stock FPS - 90hz"
										else
											ui_print "   No!!... Install Stock FPS - 60hz"
										fi;
										ui_print " "
										if $FUNCTION; then
											# 71hz
											ui_print "-> Display 71hz Selected.."
											install_dhz="  -> Display 71hz...";
											#if [ -f $compressed_image ]; then
												# Concatenate all of the dtbs to the kernel
												vhz=71
											#fi
										else
											if [ -f $home/$dtb_se/$doc_mode/75/beryllium-mp-v2.1.dtb ]; then
												set75
											elif [ -f $home/$dtb_se/$doc_mode/81/beryllium-mp-v2.1.dtb ]; then
												set81
											else
												set90
											fi
										fi
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi

	dpoc=1
}

gpu_select3(){
	ui_print " "
	ui_print "Choose GPU to install.."
	ui_print " "
	ui_print "Select GPU OC"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes.. OC 845 MHz"
	ui_print "   No!!... Choose again"
	ui_print " "
	if $FUNCTION; then
		ui_print "-> OC GPU 845 MHz Selected.."
		install_ocd="  -> OC GPU 845 MHz..."
		doc_mode=4;
		select_ocd;
	else
		gpu_select1
	fi;
}

gpu_select2(){
	ui_print " "
	ui_print "Choose GPU to install.."
	ui_print " "
	ui_print "Select GPU OC"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes.. OC 855 MHz"
	ui_print "   No!!... Choose again"
	ui_print " "
	if $FUNCTION; then
		ui_print "-> OC GPU 855 MHz Selected.."
		install_ocd="  -> OC GPU 855 MHz..."
		doc_mode=3;
		select_ocd;
	else
		if [ -d $home/$dtb_se/4 ]; then
			gpu_select3;
		else
			gpu_select1;
		fi;
	fi;
}

gpu_select4(){
	ui_print " "
	ui_print "Choose GPU to install.."
	ui_print " "
	ui_print "Select GPU OC"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes.. OC 840 MHz"
	ui_print "   No!!... Choose again"
	ui_print " "
	if $FUNCTION; then
		ui_print "-> OC GPU 840 MHz Selected.."
		install_ocd="  -> OC GPU 840 MHz..."
		doc_mode=3;
		select_ocd;
	else
		gpu_select1;
	fi;
}

gpu_select1(){
	ui_print " "
	ui_print "Choose GPU to install.."
	ui_print " "
	ui_print "Select GPU OC"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes.. OC 835 MHz"
	ui_print "   No!!... OC 820 MHz"
	ui_print " "
	if $FUNCTION; then
		ui_print "-> OC GPU 835 MHz Selected.."
		install_ocd="  -> OC GPU 835 MHz..."
		doc_mode=1;
		select_ocd;
	else
		ui_print "-> OC GPU 820 MHz Selected.."
		install_ocd="  -> OC GPU 820 MHz..."
		doc_mode=2;
		select_ocd;
	fi;
}

# Choose Permissive or Enforcing
ui_print " "
ui_print "Choose OC - Non OC.."
ui_print " "
ui_print "Select OC or Stock?"
ui_print " "
ui_print "   Vol+ = Yes, Vol- = No"
ui_print ""
ui_print "   Yes.. OC Mode"
ui_print "   No!!... Stock Mode"
ui_print " "

if $FUNCTION; then
	ui_print "-> With OC Selected.."
	# Choose Permissive or Enforcing
	ui_print " "
	ui_print "Choose GPU OC - Non OC.."
	ui_print " "
	ui_print "Select GPU OC or Stock?"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes.. OC GPU"
	ui_print "   No!!... Stock GPU"
	ui_print " "
	if $FUNCTION; then
		ui_print "-> OC GPU Selected.."
		if [ -d $home/$dtb_se/3 ]; then
			gpu_select4;
	#		gpu_select2;
	#	elif [ -d $home/$dtb_se/4 ]; then
	#		gpu_select3;
		else
			gpu_select1;
		fi;
	else
		ui_print "-> Stock GPU Selected.."
		install_ocd="  -> Stock GPU..."
		doc_mode=0;
		select_ocd;
	fi;
else
	ui_print "-> Stock Selected.."
	install_ocd="  -> Stock GPU..."
	if [ $se_main == 1 ]; then
		dtb_se=kernel/dtbs/noc/se
	else
		dtb_se=kernel/dtbs/noc/nse
	fi;
	install_dhz="  -> Display 60hz...";
	
	dpoc=0
fi

# Choose Permissive or Enforcing
ui_print " "
ui_print "Choose Default Selinux to Install.."
ui_print " "
ui_print "Permissive Or Enforcing Kernel?"
ui_print " "
ui_print "   Vol+ = Yes, Vol- = No"
ui_print ""
ui_print "   Yes.. Permissive"
ui_print "   No!!... Enforcing"
ui_print " "

if $FUNCTION; then
	ui_print "-> Permissive Kernel Selected.."
	install_pk="  -> Permissive Kernel..."
	patch_cmdline androidboot.selinux androidboot.selinux=permissive
else
	ui_print "-> Enforcing Kernel Selected.."
	install_pk="  -> Enforcing Kernel..."
	patch_cmdline androidboot.selinux androidboot.selinux=enforcing
fi

umount /system || true
umount /vendor || true
mount -o rw /dev/block/bootdevice/by-name/system /system
mount -o rw /dev/block/bootdevice/by-name/vendor /vendor
if [ -f /system/build.prop ]; then
	patch_build=/system/build.prop
else
	if [ -f /system/system/build.prop ]; then
		patch_build=/system/system/build.prop
	else
		if [ -f /system_root/system/build.prop ]; then
			patch_build=/system_root/system/build.prop
		else
			if [ -f /system/system_root/system/build.prop ]; then
				patch_build=/system_root/system/build.prop
			else
				patch_build=0
			fi
		fi
	fi
fi;

if [ -d $home/kernel/net/A10 ]; then
	# Choose Permissive or Enforcing
	ui_print " "
	ui_print "Choose Default System.."
	ui_print " "
	ui_print "Install with Nethunter ?"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes.. With Nethunter"
	ui_print "   No!!... Without Nethunter"
	ui_print " "

	if $FUNCTION; then
		ui_print "-> With support Nethunter.."
		netht="net";
	else
		ui_print "-> Without support Nethunter.."
		if [ $doc_mode = 3 ]; then
			netht="max";
		else
			netht="oc";
		fi;
	fi
else
	if [ $doc_mode = 3 ]; then
		netht="max";
	else
		netht="oc";
	fi;
fi;

if [ $patch_build = 0 ]; then
	# Choose Android
	ui_print "  "
	ui_print "Choose Android Version"
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print "   Yes!!... Android 10 - 13.1"
	ui_print "   No!!... Android 9"
	ui_print " "
	if $FUNCTION; then
		install_av="  -> Android : 10 - 13.1"
		decompressed_image=$home/kernel/$netht/A10/Image
	else
		install_av="  -> Android : 9"
		decompressed_image=$home/kernel/$netht/A9/Image
	fi
else
	decompressed_image=$home/kernel/$netht/A10/Image
	if ! grep -q 'ro.system.build.version.sdk=34' $patch_build; then
		if ! grep -q 'ro.system.build.version.sdk=33' $patch_build; then
			if ! grep -q 'ro.system.build.version.sdk=32' $patch_build; then
				if ! grep -q 'ro.system.build.version.sdk=31' $patch_build; then
					if ! grep -q 'ro.system.build.version.sdk=30' $patch_build; then
						if ! grep -q 'ro.system.build.version.sdk=29' $patch_build; then
							install_av="  -> Android : 9"
							decompressed_image=$home/kernel/$netht/A9/Image
						else
							install_av="  -> Android : 10"
						fi;
					else
						install_av="  -> Android : 11"
					fi;
				else
					install_av="  -> Android : 12"
				fi
			else
				install_av="  -> Android : 12.1"
			fi
		else
			install_av="  -> Android : 13"
		fi
	else
		install_av="  -> Android : 13.1"
	fi
fi
# Start Install Init
#. /tmp/anykernel/tools/init.sh;

# Make image
compressed_image=$decompressed_image.gz
if [ $dpoc = 1 ]; then
	if [ -f $compressed_image ]; then
		cat $compressed_image $home/$dtb_se/$doc_mode/$vhz/*.dtb $home/$dtb_se_dip/$doc_mode/*.dtb > $home/Image.gz-dtb;
	fi
else
	if [ -f $compressed_image ]; then
		cat $compressed_image $home/$dtb_se/*.dtb > $home/Image.gz-dtb;
	fi
fi;

if [ -f /vendor/etc/init/init.miui.rc ]; then
	rm -f /vendor/etc/init/init.miui.rc
fi;
if [ -f /system/etc/init/init.miui.rc ]; then
	rm -f /system/etc/init/init.miui.rc
fi;
if [ -f /system/bin/rw-vendor.sh ]; then
	rm -f /system/bin/rw-vendor.sh
fi;
if [ -f /system/bin/rw-system.sh ]; then
	sed -i "/over/c\    fixSPL" /system/bin/rw-system.sh
fi;
if [ -f /system_root/runtests.sh ]; then
	rm -f /system_root/runtests.sh
fi;

if [ ! -f $D8G_DIR/wallset ]; then echo "Installing Wallpaper R·O·G" >> $D8G_DIR/wallset;fi;
echo "Install DKM" >> $D8G_DIR/idkm;

if [ -f $D8G_DIR/pure ]; then
	rm -f $D8G_DIR/pure;
fi;


ui_print " "
ui_print "Installing D8G Kernel with :"
ui_print "$install_dv"
ui_print "$install_av"
ui_print "$install_cpu"
ui_print "$install_ocd"
ui_print "$install_dhz"
ui_print "$install_pk"
ui_print "$install_se"
if [ $netht = "net" ]; then
ui_print "  -> Nethunter"
fi;
ui_print " "
ui_print "Get all D8G feature ?"
ui_print "------------------------------------"
ui_print "Download module and install it using KSU"
ui_print " "
ui_print "Note :"
ui_print "--------"
ui_print "KSU not support thermal module now,"
ui_print " "
echo 0 > $D8G_DIR/pure;

umount /system || true
umount /vendor || true
