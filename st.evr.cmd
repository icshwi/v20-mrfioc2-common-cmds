require mrfioc2,2.2.0-rc4
require recsync,1.3.0
# require evrseq,master
require evrseq,0.1.0
require pva2pva,1.0.0
require detectorinterface,v0.1
require stream,2.7.14p

# These environment variables are set by the calling script
# epicsEnvSet("SYS", "VIP-EVR-1")
# epicsEnvSet("PCI_SLOT", "1:0.0")
# epicsEnvSet("DEVICE", "evr:2")

epicsEnvSet("TOP", "$(E3_CMD_TOP)")
epicsEnvSet("RECSYNC_CMD_TOP", "$(TOP)/../../e3/e3-recsync/cmds")
iocshLoad("$(RECSYNC_CMD_TOP)/recsync.cmd", "IOC=$(SYS)-$(DEVICE)")

epicsEnvSet("EVRSEQ_CMD_TOP", "$(E3_MODULES)/e3-evrseq/ics-evr-seq-dev/iocBoot/iocevrseqcalc")
epicsEnvSet("EVRSEQ_DB_TOP", "$(E3_MODULES)/e3-evrseq/ics-evr-seq-dev/evrseqcalcApp/Db")



mrmEvrSetupPCI("$(EVR)", $(PCI_SLOT))
dbLoadRecords("evr-pcie-300dc-ess.db","EVR=$(EVR),SYS=$(SYS),D=$(DEVICE),FEVT=88.0525,PINITSEQ=0")

dbLoadTemplate("/opt/epics/modules/esschic/nicklasholmberg2/db/esschicTimestampBuffer.substitutions", "CHIC_SYS=$(CHIC_SYS), CHOP_DRV=$(CHOP_DRV), SYS=$(SYS), DEVICE=$(CHIC_DEV):")

# Load the sequencer configuration script
#iocshLoad("$(EVRSEQ_CMD_TOP)/evrseq.cmd", "DEV1=$(CHOP_DRV)01:, DEV2=$(CHOP_DRV)02:, DEV3=$(CHOP_DRV)03:, DEV4=$(CHOP_DRV)04:, SYS_EVRSEQ=$(CHIC_SYS), EVR_EVRSEQ=$(CHIC_DEV):, NCG_SYS=$(NCG_SYS), NCG_DRV=$(NCG_DRV)")

# The amount of time which the EVR will wait for the 1PPS event before going into error state.
var(evrMrmTimeNSOverflowThreshold, 1000000)

############# -------- Detector Readout Interface ----------------- ##################
epicsEnvSet("DETINT_CMD_TOP", "$(E3_MODULES)/e3-detectorinterface/m-epics-detectorinterface-dev/cmds")
epicsEnvSet("DETINT_DB_TOP", "$(E3_MODULES)/e3-detectorinterface/m-epics-detectorinterface-dev/db")
epicsEnvSet("STREAM_PROTOCOL_PATH","$(E3_MODULES)/e3-detectorinterface/m-epics-detectorinterface-dev/protocol")

epicsEnvSet("DET_CLK_RST_EVT", "15")
epicsEnvSet("DET_RST_EVT", "15")
epicsEnvSet("SYNC_EVNT_LETTER", "EvtF")
epicsEnvSet("SYNC_TRIG_EVT", "16")



# Load the detector interface module
iocshLoad("$(DETINT_CMD_TOP)/detint.cmd", "DEV1=RO1, DEV2=RO2, COM1=COM1, COM2=COM2, SYS=$(SYS), SYNC_EVNT=$(DET_RST_EVT), SYNC_EVNT_LETTER=$(SYNC_EVNT_LETTER), N_SEC_TICKS=88052500 ")

# Connect the Prescalers

# Connect the pulsers to events and prescalers



iocInit()

# Global default values
# Set the frequency that the EVR expects from the EVG for the event clock 
dbpf $(SYS)-$(DEVICE):Time-Clock-SP 88.0525

# Connect prescaler reset to event DET_CLK_RST_EVT
dbpf $(SYS)-$(DEVICE):Evt-ResetPS-SP DET_CLK_RST_EVT

# Connect FP08 to PS0
dbpf $(SYS)-$(DEVICE):OutFPUV08-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV08-Src-SP 40 
dbpf $(SYS)-$(DEVICE):PS0-Div-SP 2

# Map pulser 9 to event code SYNC_TRIG_EVT
dbpf $(SYS)-$(DEVICE):DlyGen9-Evt-Trig0-SP 16
dbpf $(SYS)-$(DEVICE):DlyGen9-Width-SP 10

# Connect FP09 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV09-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV09-Src-SP 9 

# Connect FP10 to PS0
dbpf $(SYS)-$(DEVICE):OutFPUV10-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV10-Src-SP 40 

# Connect FP11 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV11-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV11-Src-SP 9 

# Connect FP2 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV02-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV02-Src-SP 9 

dbpf $(SYS)-$(DEVICE):OutFPUV03-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV03-Src-SP 40 



# Connect the pulsers to events and prescalers


