#!/bin/bash
PACKAGE=package.tar.gz

# Echo exact command
echo "$(basename $0) $*"


###################################################################################################
# ProjectMetis/CondorTask specific (Setting up some common environment)
###################################################################################################
#echo "To check whether it's on condor universe Vanilla or Local. The following variables are used."
#echo "If _CONDOR_SLOT is set, it's on Vanilla"
#echo "If X509_USER_PROXY is set, it's either on Vanilla or Local."
# if 
if [ "x${_CONDOR_JOB_AD}" == "x" ]; then
    :
    INPUTFILENAMES=$1
    shift;
else
    hostname
    uname -a
    date
    whoami
    pwd
    echo "ls'ing hadoop"
    ls -lh /hadoop/cms/store/user/phchang/
    echo "_CONDOR_SLOT" ${_CONDOR_SLOT}
    echo "X509_USER_PROXY" ${X509_USER_PROXY}
    echo "_CONDOR_SCRATCH_DIR"             ${_CONDOR_SCRATCH_DIR}
    echo "_CONDOR_SLOT"                    ${_CONDOR_SLOT}
    echo "CONDOR_VM"                       ${CONDOR_VM}
    echo "X509_USER_PROXY"                 ${X509_USER_PROXY}
    echo "_CONDOR_JOB_AD"                  ${_CONDOR_JOB_AD}
    echo "_CONDOR_MACHINE_AD"              ${_CONDOR_MACHINE_AD}
    echo "_CONDOR_JOB_IWD"                 ${_CONDOR_JOB_IWD}
    echo "_CONDOR_WRAPPER_ERROR_FILE"      ${_CONDOR_WRAPPER_ERROR_FILE}
    echo "CONDOR_IDS"                      ${CONDOR_IDS}
    echo "CONDOR_ID"                       ${CONDOR_ID}
    OUTPUTDIR=$1
    OUTPUTNAME=$2
    INPUTFILENAMES=$3
    IFILE=$4
    CMSSWVERSION=$5
    SCRAMARCH=$6
    if [ "x${_CONDOR_SLOT}" == "x" ]; then
        WORKDIR=/tmp/phchang_condor_local_${OUTPUTDIR//\//_}_${OUTPUTNAME}_${IFILE}
        mkdir -p ${WORKDIR}
        ls
        cp package.tar.gz ${WORKDIR}
        cd ${WORKDIR}
        ls
        echo "This is in Condor session with Universe=Local."
        echo "WORKDIR=${WORKDIR}"
        echo "pwd"
        pwd
    fi
    echo "OUTPUTDIR     : $1"
    echo "OUTPUTNAME    : $2"
    echo "INPUTFILENAMES: $3"
    echo "IFILE         : $4"
    echo "CMSSWVERSION  : $5"
    echo "SCRAMARCH     : $6"
    shift 6
    #tar xvzf package.tar.gz
    #if [ $? -eq 0 ]; then
    #    echo "Successfully untarred package."
    #    :
    #else
    #    echo "Failed to untar package."
    #    exit
    #fi
fi
###################################################################################################

#OUTPUTDIR=$1
#OUTPUTNAME=$2
#INPUTFILENAMES=$3
#IFILE=$4
#CMSSWVERSION=$5
#SCRAMARCH=$6

OUTDIR=${OUTPUTDIR}
OUTPUT=${OUTPUTNAME}
JOBNUM=${IFILE}
RANDOMSEED=123${IFILE}
TAG=""

if [ -z ${OUTDIR} ]; then usage; fi
if [ -z ${OUTPUT} ]; then usage; fi
if [ -z ${JOBNUM} ]; then usage; fi
if [ -z ${RANDOMSEED} ]; then usage; fi

# Verbose
date
echo "================================================"
echo "$(basename $0) $*"
echo "------------------------------------------------"
echo "FRAGMENT          : ${FRAGMENT}"
echo "OUTDIR            : ${OUTDIR}"
echo "OUTPUT            : ${OUTPUT}"
echo "JOBNUM            : ${JOBNUM}"
echo "RANDOMSEED        : ${RANDOMSEED}"
echo "CMSSWVERSION      : ${CMSSWVERSION}"
echo "TAG               : ${TAG}"
echo "================================================"

rm -rf scan/${JOBNUM}
mkdir -p scan/${JOBNUM}
cd scan/${JOBNUM}

# Or wherever doAnalysis is
cp ../../package.tar.gz .
tar xvzf package.tar.gz
source rooutil/root.sh

mkdir -p hists/2016
mkdir -p hists/2017
mkdir -p hists/2018
mkdir -p hists/Run2

(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/data_skim.root           -o hists/2016/data_skim.root           > hists/2016/data_skim.log           2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/ddfakes_0_skim.root      -o hists/2016/ddfakes_0_skim.root      > hists/2016/ddfakes_0_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/ddfakes_1_skim.root      -o hists/2016/ddfakes_1_skim.root      > hists/2016/ddfakes_1_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/ddfakes_2_skim.root      -o hists/2016/ddfakes_2_skim.root      > hists/2016/ddfakes_2_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/fakes_skim.root          -o hists/2016/fakes_skim.root          > hists/2016/fakes_skim.log          2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/lostlep_0_skim.root      -o hists/2016/lostlep_0_skim.root      > hists/2016/lostlep_0_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/lostlep_1_skim.root      -o hists/2016/lostlep_1_skim.root      > hists/2016/lostlep_1_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/lostlep_2_skim.root      -o hists/2016/lostlep_2_skim.root      > hists/2016/lostlep_2_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/photon_skim.root         -o hists/2016/photon_skim.root         > hists/2016/photon_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/prompt_skim.root         -o hists/2016/prompt_skim.root         > hists/2016/prompt_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/qflip_skim.root          -o hists/2016/qflip_skim.root          > hists/2016/qflip_skim.log          2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/signal_private_skim.root -o hists/2016/signal_private_skim.root > hists/2016/signal_private_skim.log 2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/signal_skim.root         -o hists/2016/signal_skim.root         > hists/2016/signal_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/vh_private_skim.root     -o hists/2016/vh_private_skim.root     > hists/2016/vh_private_skim.log     2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2016_v5.1.9/bdt_skim_slim/www_private_skim.root    -o hists/2016/www_private_skim.root    > hists/2016/www_private_skim.log    2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/data_skim.root           -o hists/2017/data_skim.root           > hists/2017/data_skim.log           2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/ddfakes_0_skim.root      -o hists/2017/ddfakes_0_skim.root      > hists/2017/ddfakes_0_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/ddfakes_1_skim.root      -o hists/2017/ddfakes_1_skim.root      > hists/2017/ddfakes_1_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/ddfakes_2_skim.root      -o hists/2017/ddfakes_2_skim.root      > hists/2017/ddfakes_2_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/fakes_skim.root          -o hists/2017/fakes_skim.root          > hists/2017/fakes_skim.log          2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/lostlep_0_skim.root      -o hists/2017/lostlep_0_skim.root      > hists/2017/lostlep_0_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/lostlep_1_skim.root      -o hists/2017/lostlep_1_skim.root      > hists/2017/lostlep_1_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/lostlep_2_skim.root      -o hists/2017/lostlep_2_skim.root      > hists/2017/lostlep_2_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/photon_skim.root         -o hists/2017/photon_skim.root         > hists/2017/photon_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/prompt_skim.root         -o hists/2017/prompt_skim.root         > hists/2017/prompt_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/qflip_skim.root          -o hists/2017/qflip_skim.root          > hists/2017/qflip_skim.log          2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/signal_private_skim.root -o hists/2017/signal_private_skim.root > hists/2017/signal_private_skim.log 2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/signal_skim.root         -o hists/2017/signal_skim.root         > hists/2017/signal_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/vh_private_skim.root     -o hists/2017/vh_private_skim.root     > hists/2017/vh_private_skim.log     2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2017_v5.1.9/bdt_skim_slim/www_private_skim.root    -o hists/2017/www_private_skim.root    > hists/2017/www_private_skim.log    2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/data_skim.root           -o hists/2018/data_skim.root           > hists/2018/data_skim.log           2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/ddfakes_0_skim.root      -o hists/2018/ddfakes_0_skim.root      > hists/2018/ddfakes_0_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/ddfakes_1_skim.root      -o hists/2018/ddfakes_1_skim.root      > hists/2018/ddfakes_1_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/ddfakes_2_skim.root      -o hists/2018/ddfakes_2_skim.root      > hists/2018/ddfakes_2_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/fakes_skim.root          -o hists/2018/fakes_skim.root          > hists/2018/fakes_skim.log          2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/lostlep_0_skim.root      -o hists/2018/lostlep_0_skim.root      > hists/2018/lostlep_0_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/lostlep_1_skim.root      -o hists/2018/lostlep_1_skim.root      > hists/2018/lostlep_1_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/lostlep_2_skim.root      -o hists/2018/lostlep_2_skim.root      > hists/2018/lostlep_2_skim.log      2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/photon_skim.root         -o hists/2018/photon_skim.root         > hists/2018/photon_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/prompt_skim.root         -o hists/2018/prompt_skim.root         > hists/2018/prompt_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/qflip_skim.root          -o hists/2018/qflip_skim.root          > hists/2018/qflip_skim.log          2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/signal_private_skim.root -o hists/2018/signal_private_skim.root > hists/2018/signal_private_skim.log 2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/signal_skim.root         -o hists/2018/signal_skim.root         > hists/2018/signal_skim.log         2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/vh_private_skim.root     -o hists/2018/vh_private_skim.root     > hists/2018/vh_private_skim.log     2>&1)
(set -x ;./doAnalysis -s ${JOBNUM} -m 9 -t t -n -1 -i www_optimization/WWW2018_v5.1.9/bdt_skim_slim/www_private_skim.root    -o hists/2018/www_private_skim.root    > hists/2018/www_private_skim.log    2>&1)
(set -x ;hadd -f hists/2016/ddfakes_skim.root hists/2016/ddfakes_?_skim.root > hists/2016/ddfakes_skim.log 2>&1)
(set -x ;hadd -f hists/2016/lostlep_skim.root hists/2016/lostlep_?_skim.root > hists/2016/lostlep_skim.log 2>&1)
(set -x ;hadd -f hists/2017/ddfakes_skim.root hists/2017/ddfakes_?_skim.root > hists/2017/ddfakes_skim.log 2>&1)
(set -x ;hadd -f hists/2017/lostlep_skim.root hists/2017/lostlep_?_skim.root > hists/2017/lostlep_skim.log 2>&1)
(set -x ;hadd -f hists/2018/ddfakes_skim.root hists/2018/ddfakes_?_skim.root > hists/2018/ddfakes_skim.log 2>&1)
(set -x ;hadd -f hists/2018/lostlep_skim.root hists/2018/lostlep_?_skim.root > hists/2018/lostlep_skim.log 2>&1)
(set -x ;hadd -f hists/Run2/data.root           hists/201*/data_skim.root           > hists/Run2/data.log            2>&1)
(set -x ;hadd -f hists/Run2/ddfakes.root        hists/201*/ddfakes_skim.root        > hists/Run2/ddfakes.log         2>&1)
(set -x ;hadd -f hists/Run2/fakes.root          hists/201*/fakes_skim.root          > hists/Run2/fakes.log           2>&1)
(set -x ;hadd -f hists/Run2/lostlep.root        hists/201*/lostlep_skim.root        > hists/Run2/lostlep.log         2>&1)
(set -x ;hadd -f hists/Run2/photon.root         hists/201*/photon_skim.root         > hists/Run2/photon.log          2>&1)
(set -x ;hadd -f hists/Run2/prompt.root         hists/201*/prompt_skim.root         > hists/Run2/prompt.log          2>&1)
(set -x ;hadd -f hists/Run2/qflip.root          hists/201*/qflip_skim.root          > hists/Run2/qflip.log           2>&1)
(set -x ;hadd -f hists/Run2/signal_private.root hists/201*/signal_private_skim.root > hists/Run2/signal_private.log  2>&1)
(set -x ;hadd -f hists/Run2/signal.root         hists/201*/signal_skim.root         > hists/Run2/signal.log          2>&1)
(set -x ;hadd -f hists/Run2/vh_private.root     hists/201*/vh_private_skim.root     > hists/Run2/vh_private.log      2>&1)
(set -x ;hadd -f hists/Run2/www_private.root    hists/201*/www_private_skim.root    > hists/Run2/www_private.log     2>&1)

mv rooutil/*.py .
python write_datacard.py
sh runcombine.sh www.txt > combine.log 2>&1

tar -cvzf output.tgz hists combine.log

FINALOUTPUT=output.tgz

gfal-copy -p -f -t 4200 --verbose file://`pwd`/${FINALOUTPUT} gsiftp://gftp.t2.ucsd.edu/${OUTPUTDIR}/${OUTPUTNAME}_${IFILE}.root --checksum ADLER32
