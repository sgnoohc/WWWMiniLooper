#!/bin/env python

import plottery_wrapper as p

p.dump_plot(
        fnames=[
            "hists/Run2/photon.root",
            "hists/Run2/qflip.root",
            "hists/Run2/ddfakes.root",
            "hists/Run2/lostlep.root",
            "hists/Run2/prompt.root",
            "hists/Run2/signal.root",
            ],
        sig_fnames=[
            ],
        filter_pattern="__Mjj",
        usercolors = [920, 2007, 2005, 2003, 2001, 2011],
        dogrep=True,
        extraoptions={
            "signal_scale":1,
            "nbins":30,
            "bkg_sort_method":"unsorted",
            }
        )
