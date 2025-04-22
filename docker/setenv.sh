#export EPICS_CA_ADDR_LIST=`cat /usr/local/tomcat/bin/EPICS_ADDR_LIST | xargs echo`
#export EPICS_PVA_ADDR_LIST=`cat /usr/local/tomcat/bin/EPICS_ADDR_LIST | xargs echo`
export WHITELIST1=file:/displays/CSS/.*
export WHITELIST2=http://vclx4.fnal.gov/.*
export PV_DEFAULT_TYPE=pva

# ========== End old settings (unicast) =========== #
export EPICS_HOST_INTERFACE='enp65s0f0'
export EPICS_PVA_ADDR_LIST="239.128.1.6,8@$EPICS_HOST_INTERFACE 239.128.1.6" # mcast search (PVXS lib)

#source /usr/local/epics/Config/epicsENV
source /usr/local/tomcat/bin/epicsENV
