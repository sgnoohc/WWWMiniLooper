#!/bin/env python

import ROOT as r

f = r.TFile("signal.root")
t = f.Get("t");

f_SRSSee = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSeeMjjIn.root", "recreate")
t_SRSSee = t.CopyTree("SRSSee==1&&nj30>=2")
t_SRSSee.Write()

f_SRSSem = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSemMjjIn.root", "recreate")
t_SRSSem = t.CopyTree("SRSSem==1&&nj30>=2")
t_SRSSem.Write()

f_SRSSmm = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSmmMjjIn.root", "recreate")
t_SRSSmm = t.CopyTree("SRSSmm==1&&nj30>=2")
t_SRSSmm.Write()

f_SRSSee = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSeeMjjOut.root", "recreate")
t_SRSSee = t.CopyTree("SRSSee==1&&nj30>=2")
t_SRSSee.Write()

f_SRSSem = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSemMjjOut.root", "recreate")
t_SRSSem = t.CopyTree("SRSSem==1&&nj30>=2")
t_SRSSem.Write()

f_SRSSmm = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSmmMjjOut.root", "recreate")
t_SRSSmm = t.CopyTree("SRSSmm==1&&nj30>=2")
t_SRSSmm.Write()

f_SRSSee = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSS1Jee.root", "recreate")
t_SRSSee = t.CopyTree("SRSSee==1&&nj30==1")
t_SRSSee.Write()

f_SRSSem = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSS1Jem.root", "recreate")
t_SRSSem = t.CopyTree("SRSSem==1&&nj30==1")
t_SRSSem.Write()

f_SRSSmm = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSS1Jmm.root", "recreate")
t_SRSSmm = t.CopyTree("SRSSmm==1&&nj30==1")
t_SRSSmm.Write()

f_SR0SFOS = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SR0SFOS.root", "recreate")
t_SR0SFOS = t.CopyTree("SR0SFOS==1")
t_SR0SFOS.Write()

f_SR1SFOS = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SR1SFOS.root", "recreate")
t_SR1SFOS = t.CopyTree("SR1SFOS==1")
t_SR1SFOS.Write()

f_SR2SFOS = r.TFile("/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SR2SFOS.root", "recreate")
t_SR2SFOS = t.CopyTree("SR2SFOS==1")
t_SR2SFOS.Write()
