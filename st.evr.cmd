require mrfioc2,2.2.0-rc2
require recsync,1.3.0

# epicsEnvSet("SYS", "VIP-EVR-2")
# epicsEnvSet("PCI_SLOT", "1:0.0")
# epicsEnvSet("DEVICE", "evr:1")

epicsEnvSet("TOP", "$(E3_CMD_TOP)")
epicsEnvSet("RECSYNC_CMD_TOP", "$(TOP)/../../e3/e3-recsync/cmds")

iocshLoad "$(RECSYNC_CMD_TOP)/recsync.cmd"

mrmEvrSetupPCI("$(EVR)", $(PCI_SLOT))
dbLoadRecords("evr-pcie-300dc-ess.db","EVR=$(DEVICE),SYS=$(SYS),D=$(DEVICE),FEVT=88.0519,PINITSEQ=0")

dbLoadRecords("/opt/epics/modules/esschic/2.2.0/db/esschicTimestampBuffer.template", "PREFIX=$(CHICSYS), DRIVEID=$(CHICID), TDC_TIME_LINK=$(SYS)-$(DEVICE):EvtACnt-I.TIME, BEAMPULSE_TIME_LINK=$(SYS)-$(DEVICE):EvtECnt-I.TIME, TSARR_N=50")

# The amount of time which the EVR will wait for the 1PPS event before going into error state.
var(evrMrmTimeNSOverflowThreshold, 100000)

iocInit()

# Set delay compensation target to 70. This is required even when delay compensation
# is disabled to avoid occasionally corrupting timestamps.
dbpf $(SYS)-$(DEVICE):DC-Tgt-SP 70

######### INPUTS #########

# Set up of UnivIO 0 as Input. Generate Code 10 locally on rising edge.
dbpf $(SYS)-$(DEVICE):OutFPUV00-Src-SP 61
dbpf $(SYS)-$(DEVICE):In0-Trig-Ext-Sel "Edge"
dbpf $(SYS)-$(DEVICE):In0-Code-Ext-SP 10

######### OUTPUTS #########
dbpf $(SYS)-$(DEVICE):DlyGen1-Evt-Trig0-SP 14
dbpf $(SYS)-$(DEVICE):DlyGen1-Width-SP 2860 #1ms
dbpf $(SYS)-$(DEVICE):DlyGen1-Delay-SP 0 #0ms
dbpf $(SYS)-$(DEVICE):OutFPUV00-Src-SP 1 #Connect to DlyGen-1

#Set up output 2 to trigger on event 16
dbpf $(SYS)-$(DEVICE):DlyGen2-Width-SP 1000 #1ms
dbpf $(SYS)-$(DEVICE):DlyGen2-Delay-SP 0 #0ms
dbpf $(SYS)-$(DEVICE):DlyGen2-Evt-Trig0-SP 16
dbpf $(SYS)-$(DEVICE):OutFPUV02-Src-SP 2 #Connect to DlyGen-2

######### TIME STAMP #########

#Flnks to esschicTimestampBuffer.template
dbpf $(SYS)-$(DEVICE):EvtACnt-I.FLNK $(CHICSYS):$(CHICID):TDC
dbpf $(SYS)-$(DEVICE):EvtECnt-I.FLNK $(CHICSYS):$(CHICID):Ref


