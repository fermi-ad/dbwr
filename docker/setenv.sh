export WHITELIST3=https://dbwr-httpd.fnal.gov/displays/.*
export WHITELIST4=https://dbwr-test.fnal.gov/displays/.*
export PV_DEFAULT_TYPE=pva

# ========== End old settings (unicast) =========== #
export EPICS_HOST_INTERFACE='enp65s0f0'
export EPICS_PVA_ADDR_LIST="239.128.1.6,8@$EPICS_HOST_INTERFACE 239.128.1.6"

source /usr/local/epics/Config/epicsENV
