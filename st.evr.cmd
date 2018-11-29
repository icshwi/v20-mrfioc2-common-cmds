require mrfioc2,2.2.0-rc4
require recsync,1.3.0
#require evrseq,0.1.0
require pva2pva,1.0.0

# These environment variables are set by the calling script
# epicsEnvSet("SYS", "VIP-EVR-1")
# epicsEnvSet("PCI_SLOT", "1:0.0")
# epicsEnvSet("DEVICE", "evr:2")

epicsEnvSet("TOP", "$(E3_CMD_TOP)")
epicsEnvSet("RECSYNC_CMD_TOP", "$(TOP)/../../e3/e3-recsync/cmds")
iocshLoad("$(RECSYNC_CMD_TOP)/recsync.cmd", "IOC=$(SYS)-$(DEVICE)")

#epicsEnvSet("EVRSEQ_CMD_TOP", "$(E3_MODULES)/e3-evrseq/ics-evr-seq-dev/iocBoot/iocevrseqcalc")
#epicsEnvSet("EVRSEQ_DB_TOP", "$(E3_MODULES)/e3-evrseq/ics-evr-seq-dev/evrseqcalcApp/Db")

mrmEvrSetupPCI("$(EVR)", $(PCI_SLOT))
dbLoadRecords("$(MRF_HW_DB)","EVR=$(EVR),SYS=$(SYS),D=$(DEVICE),FEVT=88.0525,PINITSEQ=0")

dbLoadTemplate("/opt/epics/modules/esschic/nicklasholmberg2/db/esschicTimestampBuffer.substitutions", "CHIC_SYS=$(CHIC_SYS), CHOP_DRV=$(CHOP_DRV), SYS=$(SYS), DEVICE=$(CHIC_DEV):")

# Load the sequencer configuration script
#iocshLoad("$(EVRSEQ_CMD_TOP)/evrseq.cmd", "DEV1=$(CHOP_DRV)01:, DEV2=$(CHOP_DRV)02:, DEV3=$(CHOP_DRV)03:, DEV4=$(CHOP_DRV)04:, SYS_EVRSEQ=$(CHIC_SYS), EVR_EVRSEQ=$(CHIC_DEV):, NCG_SYS=$(NCG_SYS), NCG_DRV=$(NCG_DRV)")

# The amount of time which the EVR will wait for the 1PPS event before going into error state.
var(evrMrmTimeNSOverflowThreshold, 1000000)

#iocInit()

# Global default values
# Set the frequency that the EVR expects from the EVG for the event clock 
#dbpf $(SYS)-$(DEVICE):Time-Clock-SP 88.0525

