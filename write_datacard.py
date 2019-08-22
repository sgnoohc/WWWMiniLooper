#!/bin/env python

from rooutil import datacard_writer as dw
from rooutil import pyrootutil as pr

bkg_hists = pr.get_histograms([
    "hists/Run2/photon.root",
    "hists/Run2/qflip.root",
    "hists/Run2/ddfakes.root",
    "hists/Run2/lostlep.root",
    "hists/Run2/prompt.root",
    ],
    "SR0SFOSOptFull__Yield")

sig_hists = pr.get_histograms([
    "hists/Run2/signal.root",
    ],
    "SR0SFOSOptFull__Yield")

bkg_hists[0].SetTitle("photon")
bkg_hists[1].SetTitle("qflip")
bkg_hists[2].SetTitle("ddfakes")
bkg_hists[3].SetTitle("lostlep")
bkg_hists[4].SetTitle("prompt")
sig_hists[0].SetTitle("signal")

# Systematics
# Supported types of input are
#    1. [TH1, TH1] # up and down variation
#    2. TH1
#    3. [float, float] # up and down variation
#    4. float
#    5. str         # direct input
#    6. [str, ... ] # direct input per bin
#    7. None
# All of the yields on these are expected to be the YIELDS AFTER SYST IS APPLIED. (i.e. NOT FRACTIONS)
# You can mix and match
systs = []

# 20% symmetric error on prompt
systs.append( ("promptSyst"  , "lnN" , [] , {"signal":0 , "prompt":"1.2" , "photon":0     , "qflip":0     , "ddfakes":0     , "lostlep":0}) )
systs.append( ("ddfakesSyst" , "lnN" , [] , {"signal":0 , "prompt":0     , "photon":0     , "qflip":0     , "ddfakes":"1.5" , "lostlep":0}) )
systs.append( ("lostlepSyst" , "lnN" , [] , {"signal":0 , "prompt":0     , "photon":0     , "qflip":0     , "ddfakes":0     , "lostlep":0}) )
systs.append( ("qflipSyst"   , "lnN" , [] , {"signal":0 , "prompt":0     , "photon":0     , "qflip":"1.5" , "ddfakes":0     , "lostlep":0}) )
systs.append( ("photonSyst"  , "lnN" , [] , {"signal":0 , "prompt":0     , "photon":"1.5" , "qflip":0     , "ddfakes":0     , "lostlep":0}) )

# Now create data card writer
# bkg2 does not need stat error as it is taken care of by CR stats
d = dw.DataCardWriter(sig=sig_hists[0], bgs=bkg_hists, data=None, systs=systs, no_stat_procs=["ddfakes", "lostlep"])

d.set_bin(1)
d.set_region_name("bin1")
d.write("www.txt")
