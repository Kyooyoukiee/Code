#!/sbin/sh

RC_INIT=init.d8g.rc
RC_DC=init.dc.rc
RC_PUBG=init.pubg.rc
RC_PROFIL=init.performance.rc
RC_VDIR=/vendor/etc/init
SH_DIR=/vendor/etc/d8g
TMP_INIT=$ramdisk/overlay.d
TMP_SH=$TMP_INIT/sbin

RM_MODULE() {
	d8g_touchi=/data/adb/modules/d8g_touchi
	balance_thermal=/data/adb/modules/balance_thermal
	d8g_thermal=/data/adb/modules/d8g_thermal
	d8g_bootpatch=/data/adb/modules/d8g_bootpatch
	d8g_amoled=/data/adb/modules/d8g_amoled
	d8g_rm=/data/adb/modules/d8g_rm

	if [ -d $d8g_touchi ]; then
		rm -rf $d8g_touchi;
	fi
	if [ -d $balance_thermal ]; then
		rm -rf $balance_thermal;
	fi
	if [ -d $d8g_thermal ]; then
		rm -rf $d8g_thermal;
	fi
	if [ -d $d8g_bootpatch ]; then
		rm -rf $d8g_bootpatch;
	fi
	if [ -d $d8g_amoled ]; then
		rm -rf $d8g_amoled;
	fi
	if [ -d $d8g_rm ]; then
		rm -rf $d8g_rm;
	fi
	if [ -d /data/app/com.diphons.dkm* ]; then
		rm -rf /data/app/com.diphons.dkm*;
	fi
}

RM_A10() {
	#rm -f $TMP_INIT/init.d8g.rc
	rm -f $TMP_INIT/$RC_DC
	rm -f $TMP_INIT/$RC_PUBG
	rm -f $TMP_INIT/$RC_PROFIL
	rm -f $TMP_SH/d8gservices
	cp $TMP_SH/d8gpure $TMP_SH/d8gservices
	rm -f $TMP_SH/d8gx
	rm -f $TMP_SH/dkm
	rm -f $TMP_SH/pubgsav
	rm -f $TMP_SH/te
	rm -f $TMP_SH/d8gpure
}

RM_A11() {
if [ -d $SH_DIR ]; then
  rm -fr $SH_DIR
fi

if [ -f $RC_VDIR/$RC_INIT ]; then
  rm -f $RC_VDIR/$RC_INIT
fi
if [ -f $RC_VDIR/$RC_DC ]; then
  rm -f $RC_VDIR/$RC_DC
fi
if [ -f $RC_VDIR/$RC_PUBG ]; then
  rm -f $RC_VDIR/$RC_PUBG
fi
if [ -f $RC_VDIR/$RC_PROFIL ]; then
  rm -f $RC_VDIR/$RC_PROFIL
fi

if [ -f $RC_VDIR/hw/$RC_INIT ]; then
  rm -f $RC_VDIR/hw/$RC_INIT
fi
if [ -f $RC_VDIR/hw/$RC_DC ]; then
  rm -f $RC_VDIR/hw/$RC_DC
fi
if [ -f $RC_VDIR/hw/$RC_PUBG ]; then
  rm -f $RC_VDIR/hw/$RC_PUBG
fi
if [ -f $RC_VDIR/hw/$RC_PROFIL ]; then
  rm -f $RC_VDIR/hw/$RC_PROFIL
fi
}

RM_A10
RM_A11
RM_MODULE
