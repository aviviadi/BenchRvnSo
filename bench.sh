#!/bin/bash

WRITE_DURATION=360
READ_DURATION=60
WAIT_SECS=4

DATA_DIR="${PWD}/DataDir"
RAVENDB_EXEC="RavenDB_Linux/Server/Raven.Server --Security.UnsecuredAccessAllowed=PublicNetwork --non-interactive --ServerUrl=http://0.0.0.0:8080 --DataDir=${DATA_DIR}"

LOG=bench.log
NC="\\e[39m"
C_BLACK="\\e[30m"
C_RED="\\e[31m"
C_GREEN="\\e[32m"
C_YELLOW="\\e[33m"
C_BLUE="\\e[34m"
C_MAGENTA="\\e[35m"
C_CYAN="\\e[36m"
C_L_GRAY="\\e[37m"
C_D_GRAY="\\e[90m"
C_L_RED="\\e[91m"
C_L_GREEN="\\e[92m"
C_L_YELLOW="\\e[93m"
C_L_BLUE="\\e[94m"
C_L_MAGENTA="\\e[95m"
C_L_CYAN="\\e[96m"
C_WHITE="\\e[97m"

echo " "
echo -e "${C_L_CYAN}Benchmark RavenDB: wrk - Writes"
echo -e "==============================="
echo -e " "
if [ $(pgrep Raven.Server | wc -l) -gt 0 ]; then
	echo -e "${C_L_RED}Cannot start benchmark while other Raven.Server process is active${NC}"
	echo "(You may kill $(pgrep Raven.Server))"
	exit 1
fi
echo -ne "${C_L_BLUE}Starting RavenDB... "
echo "" >> ${LOG}
echo "Started at $(date)" >> ${LOG}
rm -rf ${DATA_DIR} >& /dev/null
eval ${RAVENDB_EXEC} >> ${LOG} 2>&1 &
CNT=0
while [ $(pgrep Raven.Server | wc -l) -ne 1 ]
do
	CNT=$(expr ${CNT}+1)
	if [ ${CNT} -gt 10 ]; then
		echo -e "${C_L_RED}Failed to start RavenDB in reasonable time${NC}"
		exit 1
	fi
	sleep 1
done
echo -ne "${C_L_GREEN}Ok... Waiting ${WAIT_SECS} Secs... "
sleep ${WAIT_SECS}
echo -e "Done."
echo -ne "${C_L_BLUE}Creating DB...${NC}"
./Util/Util --create-databases
echo -e "${C_L_GREEN}Ok"

# wrk
echo -e "${C_L_BLUE}Warming wrk...${NC}"
./wrk/wrk -d5 -c10 -t2 http://127.0.0.1:8080 -s wrk/writes.lua -- 4 |& tee -a ${LOG}
if [ $? -ne 0 ]; then
	echo -e "${C_L_RED}Failed${NC}"
	exit 1
fi
echo -e "${C_L_BLUE}Testing wrk - Writes...${NC}"
./wrk/wrk -d${WRITE_DURATION} -c6144 -t256 http://127.0.0.1:8080 -s wrk/writes.lua -- 96 |& tee -a ${LOG}
if [ $? -ne 0 ]; then
        echo -e "${C_L_RED}Failed${NC}"
        exit 1
fi
echo -e "${C_L_BLUE}Testing wrk - Reads...${NC}"
./wrk/wrk -d${READ_DURATION} -c6144 -t256 http://127.0.0.1:8080 -s wrk/reads.lua -- 96 |& tee -a ${LOG}
if [ $? -ne 0 ]; then
        echo -e "${C_L_RED}Failed${NC}"
        exit 1
fi
echo -e "${C_L_GREEN}Done.${NC}"
echo " "

# stackoverflow
for dumptype in Users Posts Indexes;
do
	echo -ne "${C_L_BLUE}Importing Stackoverflow ${dumptype}...${NC}"
	rm -f Dumps/${dumptype}/smuggler.results.txt >& /dev/null
	curl -GET http://127.0.0.1:8080/databases/Stackoverflow/admin/smuggler/import-dir?dir=${PWD}/Dumps/${dumptype} >> ${LOG} 2>&1
	echo -ne "${C_L_GREEN}"
	cat ${PWD}/Dumps/${dumptype}/smuggler.results.txt  | grep -o "Elapsed.*" | cut -f3 -d'"'
done
echo -e "${C_L_BLUE}Waiting for non-stale indexes at `date`... ${C_L_MAGENTA}"
time ./Util/Util --non-stale |& grep "real"
echo -e "${C_L_GREEN}Done at `date`${NC}"
echo " "
pkill Raven.Server
echo "`date` : Bye bye" >> ${LOG}
echo "Bye."

