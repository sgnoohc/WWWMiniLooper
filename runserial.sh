#!/bin/bash
PACKAGE=package.tar.gz

if [ -z $1 ]; then
    echo "Usage:"
    echo "  $0 JOBNUM"
    echo ""
    exit
fi

OUTPUTDIR=$1
OUTPUTNAME=$2
INPUTFILENAMES=$3
IFILE=$4
JOBNUM=${IFILE}
MODE=9

echo $JOBNUM

rm -rf scan/${JOBNUM}
mkdir -p scan/${JOBNUM}
cd scan/${JOBNUM}

xrdcp -t 5 root://redirector.t2.ucsd.edu//store/user/phchang/www_optimization/package.root .

# Or wherever doAnalysis is
tar xvzf package.root
source rooutil/root.sh

mkdir -p hists/Run2

./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/data_skim.root                                                                                              -o hists/Run2/data.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/fakes_skim.root                                                                                             -o hists/Run2/fakes.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/photon_skim.root                                                                                            -o hists/Run2/photon.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/prompt_skim.root                                                                                            -o hists/Run2/prompt.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/qflip_skim.root                                                                                             -o hists/Run2/qflip.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/ddfakes_0_skim.root,www_optimization/v5.1.9/ddfakes_2_skim.root,www_optimization/v5.1.9/ddfakes_2_skim.root -o hists/Run2/ddfakes.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/lostlep_0_skim.root,www_optimization/v5.1.9/lostlep_1_skim.root,www_optimization/v5.1.9/lostlep_2_skim.root -o hists/Run2/lostlep.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/signal_skim.root                                                                                            -o hists/Run2/signal.root
./doAnalysis -s ${JOBNUM} -m ${MODE} -t t -n -1 -i www_optimization/v5.1.9/signal_private_skim.root                                                                                    -o hists/Run2/signal_private.root

export PYTHONPATH=$PYTHONPATH:$PWD/rooutil
export PYTHONPATH=$PYTHONPATH:$PWD/rooutil/syncfiles/pyfiles/

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
# COPY_DEST="gsiftp://gftp.t2.ucsd.edu/hadoop/cms/store/user/phchang/www_optimization/outputs/${MODE}/output_${JOBNUM}.tgz"
COPY_DEST="gsiftp://gftp.t2.ucsd.edu/hadoop/cms/store/user/phchang/www_optimization/outputs/${MODE}/output_${JOBNUM}.root"
stageout $COPY_SRC $COPY_DEST

ls -l .
