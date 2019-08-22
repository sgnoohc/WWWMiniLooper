export SCRAM_ARCH=slc6_amd64_gcc530
export CMSSW_VERSION=CMSSW_8_1_0
source /cvmfs/cms.cern.ch/cmsset_default.sh
cmsrel CMSSW_8_1_0
cd CMSSW_8_1_0/src
cmsenv
cd -
scramv1 b ProjectRename
export PYTHONPATH=$PWD/CMSSW_8_1_0/python:$PWD/CMSSW_8_1_0/lib/slc6_amd64_gcc530:$PYTHONPATH
export PATH=$PWD/CMSSW_8_1_0/bin/${SCRAM_ARCH}:$PATH
export LD_LIBRARY_PATH=$PWD/CMSSW_8_1_0/lib/${SCRAM_ARCH}:$LD_LIBRARY_PATH
export ROOT_INCLUDE_PATH=$PWD/CMSSW_8_1_0/src:$ROOT_INCLUDE_PATH
echo "PATH"
echo $PATH
echo "PYTHONPATH"
echo $PYTHONPATH
echo "LD_LIBRARY_PATH"
echo $LD_LIBRARY_PATH
ls -l $PWD/CMSSW_8_1_0/python
ls -l $PWD/CMSSW_8_1_0/python/*/
ls -l $PWD/CMSSW_8_1_0/python/*/*
pwd
ls $PWD/
ls $PWD/CMSSW_8_1_0/python/HiggsAnalysis
ls $PWD/CMSSW_8_1_0/python/HiggsAnalysis/CombinedLimit/
# export PYTHONPATH=$PYTHONPATH
combine -M ProfileLikelihood --significance $1 -t -1 --expectSignal=1 --rMin -50 --rMax 50
