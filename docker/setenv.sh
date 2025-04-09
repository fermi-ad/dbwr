# Display Runtime Default Files
#export DBWR1=file:/bob/rules.bob
#export DBWR2=file:/bob/macros.bob
#export DBWR3=file:/bob/monitors_textupdate.bob
#export DBWR4=file:/bob/DTDInsertion.bob

# Configure PVWS URL 
#export PVWS_HOST=localhost:8081
#export PVWS_WS_PROTOCOL=ws
#export PVWS_HTTP_PROTOCOL=http
#

export EPICS_CA_AUTO_ADDR_LIST= NO
#export EPICS_CA_ADDR_LIST=`cat /usr/local/epics/Config/EPICS_ADDR_LIST | xargs echo`
export EPICS_PVA_AUTO_ADDR_LIST=NO
#export EPICS_PVA_ADDR_LIST=`cat /usr/local/epics/Config/EPICS_ADDR_LIST | xargs echo`
export WHITELIST1=file:/displays/CSS/.*
export WHITELIST2=http://vclx4.fnal.gov/.*
export EPICS_IOC_IGNORE_SERVERS=rsrv
export PV_DEFAULT_TYPE=pva

##############################################
# The variable most likely to need changing 
# is this one:
export EPICS_PATH=/usr/local/epics

##############################################
# EPICS Base
export EPICS_BASE=${EPICS_PATH}/base
export EPICS_HOST_ARCH=linux-x86_64

if [[ ${PATH} != *${EPICS_BASE}/bin/${EPICS_HOST_ARCH}* ]]
then
    export PATH=${PATH}:${EPICS_BASE}/bin/${EPICS_HOST_ARCH}
fi

if ! ldconfig -p|grep --quiet /usr/local/epics/base/lib/ && \
[[ ${LD_LIBRARY_PATH} != *${EPICS_BASE}/lib/${EPICS_HOST_ARCH}* ]]
then
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
fi

########################################################################
# Kluge to find interface (hopefully temporary)
#set -- $(nmcli device status)
export EPICS_HOST_INTERFACE='eth0'

##############################################
# EPICS Network Configuration

# CA Protocol clients
export EPICS_CA_AUTO_ADDR_LIST=NO			# no broadcast search
export EPICS_CA_ADDR_LIST=239.128.1.6			# mcast searches
export EPICS_CA_MCAST_TTL=32				# search (and beacon) TTL

# CA Protocol IOC servers
export EPICS_CAS_INTF_ADDR_LIST=239.128.1.6		# mcast search listen
export EPICS_CAS_AUTO_BEACON_ADDR_LIST=NO		# no broadcast beacons
export EPICS_CAS_BEACON_ADDR_LIST="239.128.1.7"		# send mcast beacons

# PVA Protocol clients
export EPICS_PVA_AUTO_ADDR_LIST=NO			# no broadcast search
export EPICS_PVA_ADDR_LIST="239.128.1.6,8@$EPICS_HOST_INTERFACE 239.128.1.6"	# mcast search (PVXS lib)
#export EPICS_PVA_ADDR_LIST=239.128.1.6		#!!#  for PVA C++ library
						#!!#  requires TTL firewall rule
# PVA Protocol IOC servers
export EPICS_PVAS_INTF_ADDR_LIST=239.128.1.6		# mcast search listen
export EPICS_PVAS_AUTO_BEACON_ADDR_LIST=NO		# no broadcast beacons
export EPICS_PVAS_BEACON_ADDR_LIST=239.128.1.7,10	# Send mcast beacons

##############################################
# EPICS Support
export EPICS_SUPPORT=${EPICS_PATH}/Support

##############################################
# EPICS iocTops
export EPICS_IOCTOPS=${EPICS_PATH}/iocTops

##############################################
# EPICS Config
export EPICS_CONFIG=${EPICS_PATH}/Config

########################################################################
# External Libraries
export EPICS_EXTLIBS=${EPICS_PATH}/ExtLibs

########################################################################
# EPICS Tools
export EPICS_TOOLS=${EPICS_PATH}/Tools
export RPN_DEFNS=${EPICS_TOOLS}/include/defns.rpn

if [[ ${PATH} != *${EPICS_TOOLS}/bin* ]]
then
    export PATH=${PATH}:${EPICS_TOOLS}/bin/${EPICS_HOST_ARCH}
fi
if [[ ${LD_LIBRARY_PATH} != *${EPICS_TOOLS}/lib* ]]
then
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${EPICS_TOOLS}/lib/${EPICS_HOST_ARCH}
fi

########################################################################
# Turn off Channel Access
export EPICS_IOC_IGNORE_SERVERS=rsrv
