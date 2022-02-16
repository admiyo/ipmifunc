


_ipmi_exec(){
    IPMI_ADDR=$IPMI_SUBNET.$1
    shift 
    ipmitool -H $IPMI_ADDR  -U $IPMI_USER -I lanplus -P  $IPMI_PASS  $@
}



ipmi_mc_info(){
  _ipmi_exec $1 mc info

}

ipmi_all(){
 IPMI_COMMAND=$@
 for i in `seq -w 161 185`
 do 
   IPMI_ADDR=$IPMI_SUBNET.$i
   echo $IPMI_ADDR ; 
   echo ipmitool -H $IPMI_ADDR  -U $IPMI_USER -I lanplus -P $IPMI_PASS $IPMI_COMMAND
        ipmitool -H $IPMI_ADDR  -U $IPMI_USER -I lanplus -P $IPMI_PASS $IPMI_COMMAND
 done
}


ipmi_all_power_status(){
   ipmi_all power status
}

ipmi_all_check_password(){
for i in `seq -w 161 185`
 do
   ipmi_check_password $i
 done

}


ipmi_all_set_password(){
for i in `seq -w 161 185`
 do
   ipmi_set_password $i
 done

}

ipmi_pxe(){
	IPMI_SYS=$IPMI_SUBNET.$1
	ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  chassis bootdev pxe 
	ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  power off
	ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  power on
}


ipmi_disk(){
        IPMI_SYS=$IPMI_SUBNET.$1
        ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  chassis bootdev disk 
        ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  power off
        ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  power on
}


ipmi_power_cycle(){
	IPMI_SYS=$IPMI_SUBNET.$1
	ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  power off
	ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  power on
}

ipmi_bootdev_efi(){
        IPMI_SYS=$IPMI_SUBNET.$1
        ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  chassis efiboot
        ipmi_power_cycle $1
}



ipmi_bootdev_list(){
        IPMI_SYS=$IPMI_SUBNET.$1
        ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS  chassis bootdev none options=help
}


ipmi_sol_activate(){
       IPMI_SYS=$IPMI_SUBNET.$1
       echo $IPMI_SYS
       ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS sol activate 

}

ipmi_power_on(){
       IPMI_SYS=$IPMI_SUBNET.$1
       echo $IPMI_SYS
       ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS power on
}

ipmi_power_off(){
       IPMI_SYS=$IPMI_SUBNET.$1
       echo $IPMI_SYS
       ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS power off
}

ipmi_power_status(){
       IPMI_SYS=$IPMI_SUBNET.$1
       echo $IPMI_SYS       
       ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $IPMI_PASS power status
}



ipmi_check_password(){
      FOUND=0
      IPMI_SYS=$IPMI_SUBNET.$1
      for TEST_PASS in $IPMI_PASS $BAD_PASSES
      do
          ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P $TEST_PASS power status 2>&1 > /dev/null
           if [ $?  -eq 0 ]
           then
               FOUND=1
               break
           fi
      done

     if [ $FOUND -eq 1 ]
     then
        if [ $TEST_PASS == $IPMI_PASS ]
        then
           echo $IPMI_SYS  Good Password
        else
           echo $IPMI_SYS  $TEST_PASS
        fi
     else
         echo $IPMI_SYS  not found
     fi


}


ipmi_set_password(){

       IPMI_SYS=$IPMI_SUBNET.$1
       echo $IPMI_SYS
       for BAD_PASS in $BAD_PASSES
       do
           ipmitool -H $IPMI_SYS -U $IPMI_USER -I lanplus -P  $BAD_PASS user set password 2 $IPMI_PASS
       done

      ipmi_check_password $1
}

ipmi_power_status_all(){
 for i in `seq -w 161 188`
 do
  ipmi_power_status $i 
 done
}

