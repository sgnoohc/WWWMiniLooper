export SCRAM_ARCH=slc6_amd64_gcc530
export CMSSW_VERSION=CMSSW_8_1_0
source /cvmfs/cms.cern.ch/cmsset_default.sh
cmsrel CMSSW_8_1_0
cd CMSSW_8_1_0/src
cmsenv
cd -
combine -M ProfileLikelihood --significance $1 -t -1 --expectSignal=1 --rMin -50 --rMax 50
