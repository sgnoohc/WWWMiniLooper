#!/bin/bash

trap "kill 0" EXIT

mkdir -p hists/
rm -rf hists/

YEAR=2016
echo $YEAR
mkdir -p hists/${YEAR}
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/data_skim.root           -o hists/${YEAR}/data_skim.root           > hists/${YEAR}/data_skim.log           2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_0_skim.root      -o hists/${YEAR}/ddfakes_0_skim.root      > hists/${YEAR}/ddfakes_0_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_1_skim.root      -o hists/${YEAR}/ddfakes_1_skim.root      > hists/${YEAR}/ddfakes_1_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_2_skim.root      -o hists/${YEAR}/ddfakes_2_skim.root      > hists/${YEAR}/ddfakes_2_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/fakes_skim.root          -o hists/${YEAR}/fakes_skim.root          > hists/${YEAR}/fakes_skim.log          2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_0_skim.root      -o hists/${YEAR}/lostlep_0_skim.root      > hists/${YEAR}/lostlep_0_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_1_skim.root      -o hists/${YEAR}/lostlep_1_skim.root      > hists/${YEAR}/lostlep_1_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_2_skim.root      -o hists/${YEAR}/lostlep_2_skim.root      > hists/${YEAR}/lostlep_2_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/photon_skim.root         -o hists/${YEAR}/photon_skim.root         > hists/${YEAR}/photon_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/prompt_skim.root         -o hists/${YEAR}/prompt_skim.root         > hists/${YEAR}/prompt_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/qflip_skim.root          -o hists/${YEAR}/qflip_skim.root          > hists/${YEAR}/qflip_skim.log          2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/signal_private_skim.root -o hists/${YEAR}/signal_private_skim.root > hists/${YEAR}/signal_private_skim.log 2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/signal_skim.root         -o hists/${YEAR}/signal_skim.root         > hists/${YEAR}/signal_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/vh_private_skim.root     -o hists/${YEAR}/vh_private_skim.root     > hists/${YEAR}/vh_private_skim.log     2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/www_private_skim.root    -o hists/${YEAR}/www_private_skim.root    > hists/${YEAR}/www_private_skim.log    2>&1) &

YEAR=2017
echo $YEAR
mkdir -p hists/${YEAR}
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/data_skim.root           -o hists/${YEAR}/data_skim.root           > hists/${YEAR}/data_skim.log           2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_0_skim.root      -o hists/${YEAR}/ddfakes_0_skim.root      > hists/${YEAR}/ddfakes_0_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_1_skim.root      -o hists/${YEAR}/ddfakes_1_skim.root      > hists/${YEAR}/ddfakes_1_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_2_skim.root      -o hists/${YEAR}/ddfakes_2_skim.root      > hists/${YEAR}/ddfakes_2_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/fakes_skim.root          -o hists/${YEAR}/fakes_skim.root          > hists/${YEAR}/fakes_skim.log          2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_0_skim.root      -o hists/${YEAR}/lostlep_0_skim.root      > hists/${YEAR}/lostlep_0_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_1_skim.root      -o hists/${YEAR}/lostlep_1_skim.root      > hists/${YEAR}/lostlep_1_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_2_skim.root      -o hists/${YEAR}/lostlep_2_skim.root      > hists/${YEAR}/lostlep_2_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/photon_skim.root         -o hists/${YEAR}/photon_skim.root         > hists/${YEAR}/photon_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/prompt_skim.root         -o hists/${YEAR}/prompt_skim.root         > hists/${YEAR}/prompt_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/qflip_skim.root          -o hists/${YEAR}/qflip_skim.root          > hists/${YEAR}/qflip_skim.log          2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/signal_private_skim.root -o hists/${YEAR}/signal_private_skim.root > hists/${YEAR}/signal_private_skim.log 2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/signal_skim.root         -o hists/${YEAR}/signal_skim.root         > hists/${YEAR}/signal_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/vh_private_skim.root     -o hists/${YEAR}/vh_private_skim.root     > hists/${YEAR}/vh_private_skim.log     2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/www_private_skim.root    -o hists/${YEAR}/www_private_skim.root    > hists/${YEAR}/www_private_skim.log    2>&1) &

YEAR=2018
echo $YEAR
mkdir -p hists/${YEAR}
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/data_skim.root           -o hists/${YEAR}/data_skim.root           > hists/${YEAR}/data_skim.log           2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_0_skim.root      -o hists/${YEAR}/ddfakes_0_skim.root      > hists/${YEAR}/ddfakes_0_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_1_skim.root      -o hists/${YEAR}/ddfakes_1_skim.root      > hists/${YEAR}/ddfakes_1_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/ddfakes_2_skim.root      -o hists/${YEAR}/ddfakes_2_skim.root      > hists/${YEAR}/ddfakes_2_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/fakes_skim.root          -o hists/${YEAR}/fakes_skim.root          > hists/${YEAR}/fakes_skim.log          2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_0_skim.root      -o hists/${YEAR}/lostlep_0_skim.root      > hists/${YEAR}/lostlep_0_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_1_skim.root      -o hists/${YEAR}/lostlep_1_skim.root      > hists/${YEAR}/lostlep_1_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/lostlep_2_skim.root      -o hists/${YEAR}/lostlep_2_skim.root      > hists/${YEAR}/lostlep_2_skim.log      2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/photon_skim.root         -o hists/${YEAR}/photon_skim.root         > hists/${YEAR}/photon_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/prompt_skim.root         -o hists/${YEAR}/prompt_skim.root         > hists/${YEAR}/prompt_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/qflip_skim.root          -o hists/${YEAR}/qflip_skim.root          > hists/${YEAR}/qflip_skim.log          2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/signal_private_skim.root -o hists/${YEAR}/signal_private_skim.root > hists/${YEAR}/signal_private_skim.log 2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/signal_skim.root         -o hists/${YEAR}/signal_skim.root         > hists/${YEAR}/signal_skim.log         2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/vh_private_skim.root     -o hists/${YEAR}/vh_private_skim.root     > hists/${YEAR}/vh_private_skim.log     2>&1) &
(set -x ;./doAnalysis -t t -n -1 -i /nfs-7/userdata/phchang/WWW_babies/WWW${YEAR}_v5.1.9/bdt_skim_slim/www_private_skim.root    -o hists/${YEAR}/www_private_skim.root    > hists/${YEAR}/www_private_skim.log    2>&1) &

wait

YEAR=2016
(set -x; hadd hists/${YEAR}/ddfakes_skim.root hists/${YEAR}/ddfakes_?_skim.root > hists/${YEAR}/ddfakes_skim.log 2>&1) &
(set -x; hadd hists/${YEAR}/lostlep_skim.root hists/${YEAR}/lostlep_?_skim.root > hists/${YEAR}/lostlep_skim.log 2>&1) &
YEAR=2017
(set -x; hadd hists/${YEAR}/ddfakes_skim.root hists/${YEAR}/ddfakes_?_skim.root > hists/${YEAR}/ddfakes_skim.log 2>&1) &
(set -x; hadd hists/${YEAR}/lostlep_skim.root hists/${YEAR}/lostlep_?_skim.root > hists/${YEAR}/lostlep_skim.log 2>&1) &
YEAR=2018
(set -x; hadd hists/${YEAR}/ddfakes_skim.root hists/${YEAR}/ddfakes_?_skim.root > hists/${YEAR}/ddfakes_skim.log 2>&1) &
(set -x; hadd hists/${YEAR}/lostlep_skim.root hists/${YEAR}/lostlep_?_skim.root > hists/${YEAR}/lostlep_skim.log 2>&1) &

wait

mkdir -p hists/Run2

(set -x ;hadd hists/Run2/data.root           hists/201*/data_skim.root           > hists/Run2/data.log            2>&1) &
(set -x ;hadd hists/Run2/ddfakes.root        hists/201*/ddfakes_skim.root        > hists/Run2/ddfakes.log         2>&1) &
(set -x ;hadd hists/Run2/fakes.root          hists/201*/fakes_skim.root          > hists/Run2/fakes.log           2>&1) &
(set -x ;hadd hists/Run2/lostlep.root        hists/201*/lostlep_skim.root        > hists/Run2/lostlep.log         2>&1) &
(set -x ;hadd hists/Run2/photon.root         hists/201*/photon_skim.root         > hists/Run2/photon.log          2>&1) &
(set -x ;hadd hists/Run2/prompt.root         hists/201*/prompt_skim.root         > hists/Run2/prompt.log          2>&1) &
(set -x ;hadd hists/Run2/qflip.root          hists/201*/qflip_skim.root          > hists/Run2/qflip.log           2>&1) &
(set -x ;hadd hists/Run2/signal_private.root hists/201*/signal_private_skim.root > hists/Run2/signal_private.log  2>&1) &
(set -x ;hadd hists/Run2/signal.root         hists/201*/signal_skim.root         > hists/Run2/signal.log          2>&1) &
(set -x ;hadd hists/Run2/vh_private.root     hists/201*/vh_private_skim.root     > hists/Run2/vh_private.log      2>&1) &
(set -x ;hadd hists/Run2/www_private.root    hists/201*/www_private_skim.root    > hists/Run2/www_private.log     2>&1) &

wait
