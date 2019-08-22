#!/bin/bash
PACKAGE=package.tar.gz

if [ -z $1 ]; then
    echo "Usage:"
    echo "  $0 JOBNUM"
    echo ""
    exit
fi

JOBNUM=$1
MODE=9

echo $JOBNUM

rm -rf scan/${JOBNUM}
mkdir -p scan/${JOBNUM}
cd scan/${JOBNUM}

function xcp {
    dest="."
    if [ $# -gt 1 ]; then
        dest=$2
    fi
    xrdcp root://xrootd.unl.edu/$1 $dest
}

xrdcp /cms/store/user/phchang/www_optimization/package.tar.gz

# Or wherever doAnalysis is
tar xvzf package.tar.gz
source rooutil/root.sh

mkdir -p hists/2016
mkdir -p hists/2017
mkdir -p hists/2018
mkdir -p hists/Run2

./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/data_skim.root           -o hists/2016/data_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/ddfakes_0_skim.root      -o hists/2016/ddfakes_0_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/ddfakes_1_skim.root      -o hists/2016/ddfakes_1_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/ddfakes_2_skim.root      -o hists/2016/ddfakes_2_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/fakes_skim.root          -o hists/2016/fakes_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/lostlep_0_skim.root      -o hists/2016/lostlep_0_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/lostlep_1_skim.root      -o hists/2016/lostlep_1_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/lostlep_2_skim.root      -o hists/2016/lostlep_2_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/photon_skim.root         -o hists/2016/photon_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/prompt_skim.root         -o hists/2016/prompt_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/qflip_skim.root          -o hists/2016/qflip_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/signal_private_skim.root -o hists/2016/signal_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/signal_skim.root         -o hists/2016/signal_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/vh_private_skim.root     -o hists/2016/vh_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2016_v5.1.9/www_private_skim.root    -o hists/2016/www_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/data_skim.root           -o hists/2017/data_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/ddfakes_0_skim.root      -o hists/2017/ddfakes_0_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/ddfakes_1_skim.root      -o hists/2017/ddfakes_1_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/ddfakes_2_skim.root      -o hists/2017/ddfakes_2_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/fakes_skim.root          -o hists/2017/fakes_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/lostlep_0_skim.root      -o hists/2017/lostlep_0_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/lostlep_1_skim.root      -o hists/2017/lostlep_1_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/lostlep_2_skim.root      -o hists/2017/lostlep_2_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/photon_skim.root         -o hists/2017/photon_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/prompt_skim.root         -o hists/2017/prompt_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/qflip_skim.root          -o hists/2017/qflip_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/signal_private_skim.root -o hists/2017/signal_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/signal_skim.root         -o hists/2017/signal_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/vh_private_skim.root     -o hists/2017/vh_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2017_v5.1.9/www_private_skim.root    -o hists/2017/www_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/data_skim.root           -o hists/2018/data_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/ddfakes_0_skim.root      -o hists/2018/ddfakes_0_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/ddfakes_1_skim.root      -o hists/2018/ddfakes_1_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/ddfakes_2_skim.root      -o hists/2018/ddfakes_2_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/fakes_skim.root          -o hists/2018/fakes_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/lostlep_0_skim.root      -o hists/2018/lostlep_0_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/lostlep_1_skim.root      -o hists/2018/lostlep_1_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/lostlep_2_skim.root      -o hists/2018/lostlep_2_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/photon_skim.root         -o hists/2018/photon_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/prompt_skim.root         -o hists/2018/prompt_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/qflip_skim.root          -o hists/2018/qflip_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/signal_private_skim.root -o hists/2018/signal_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/signal_skim.root         -o hists/2018/signal_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/vh_private_skim.root     -o hists/2018/vh_private_skim.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/WWW2018_v5.1.9/www_private_skim.root    -o hists/2018/www_private_skim.root
hadd -f hists/2016/ddfakes_skim.root hists/2016/ddfakes_?_skim.root
hadd -f hists/2016/lostlep_skim.root hists/2016/lostlep_?_skim.root
hadd -f hists/2017/ddfakes_skim.root hists/2017/ddfakes_?_skim.root
hadd -f hists/2017/lostlep_skim.root hists/2017/lostlep_?_skim.root
hadd -f hists/2018/ddfakes_skim.root hists/2018/ddfakes_?_skim.root
hadd -f hists/2018/lostlep_skim.root hists/2018/lostlep_?_skim.root
hadd -f hists/Run2/data.root           hists/201*/data_skim.root
hadd -f hists/Run2/ddfakes.root        hists/201*/ddfakes_skim.root
hadd -f hists/Run2/fakes.root          hists/201*/fakes_skim.root
hadd -f hists/Run2/lostlep.root        hists/201*/lostlep_skim.root
hadd -f hists/Run2/photon.root         hists/201*/photon_skim.root
hadd -f hists/Run2/prompt.root         hists/201*/prompt_skim.root
hadd -f hists/Run2/qflip.root          hists/201*/qflip_skim.root
hadd -f hists/Run2/signal_private.root hists/201*/signal_private_skim.root
hadd -f hists/Run2/signal.root         hists/201*/signal_skim.root
hadd -f hists/Run2/vh_private.root     hists/201*/vh_private_skim.root
hadd -f hists/Run2/www_private.root    hists/201*/www_private_skim.root

export PYTHONPATH=$PYTHONPATH:$PWD/rooutil
export PYTHONPATH=$PYTHONPATH:$PWD/rooutil/syncfiles/pyfiles/

ls hists/2016
ls hists/2017
ls hists/2018
ls hists/Run2

python write_datacard.py
cat runcombine.sh
sh ./runcombine.sh www.txt

tar -cvzf output_${JOBNUM}.tgz hists combine.log

function stageout {
    COPY_SRC=$1
    COPY_DEST=$2
    retries=0
    COPY_STATUS=1
    until [ $retries -ge 3 ]
    do
        echo "Stageout attempt $((retries+1)): env -i X509_USER_PROXY=${X509_USER_PROXY} gfal-copy -p -f -t 7200 --verbose --checksum ADLER32 ${COPY_SRC} ${COPY_DEST}"
        env -i X509_USER_PROXY=${X509_USER_PROXY} gfal-copy -p -f -t 7200 --verbose --checksum ADLER32 ${COPY_SRC} ${COPY_DEST}
        COPY_STATUS=$?
        if [ $COPY_STATUS -ne 0 ]; then
            echo "Failed stageout attempt $((retries+1))"
        else
            echo "Successful stageout with $retries retries"
            break
        fi
        retries=$[$retries+1]
        echo "Sleeping for 30m"
        sleep 30m
    done
    if [ $COPY_STATUS -ne 0 ]; then
        echo "Removing output file because gfal-copy crashed with code $COPY_STATUS"
        env -i X509_USER_PROXY=${X509_USER_PROXY} gfal-rm --verbose ${COPY_DEST}
        REMOVE_STATUS=$?
        if [ $REMOVE_STATUS -ne 0 ]; then
            echo "Uhh, gfal-copy crashed and then the gfal-rm also crashed with code $REMOVE_STATUS"
            echo "You probably have a corrupt file sitting on hadoop now."
            exit 1
        fi
    fi
}

COPY_SRC="file://`pwd`/output_${JOBNUM}.tgz"
COPY_DEST="gsiftp://gftp.t2.ucsd.edu/hadoop/cms/store/user/phchang/www_optimization/outputs/${MODE}/output_${JOBNUM}.tgz"
stageout $COPY_SRC $COPY_DEST

ls -l .
