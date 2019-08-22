#include "wwwtree.h"
#include "rooutil.h"
#include "cxxopts.h"

class AnalysisConfig {

public:

    // TString that holds the input file list (comma separated)
    TString input_file_list_tstring;

    // TString that holds the name of the TTree to open for each input files
    TString input_tree_name;

    // Output TFile
    TFile* output_tfile;

    // Number of events to loop over
    int n_events;

    // Jobs to split (if this number is positive, then we will skip certain number of events)
    // If there are N events, and was asked to split 2 ways, then depending on job_index, it will run over first half or latter half
    int nsplit_jobs;

    // Job index (assuming nsplit_jobs is set, the job_index determine where to loop over)
    int job_index;

    // Debug boolean
    bool debug;

    // TChain that holds the input TTree's
    TChain* events_tchain;

    // Custom Looper object to facilitate looping over many files
    RooUtil::Looper<wwwtree> looper;

    // Custom Cutflow framework
    RooUtil::Cutflow cutflow;

    // Custom Histograms object compatible with RooUtil::Cutflow framework
    RooUtil::Histograms histograms;

    // Search mode
    enum SearchMode 
    {
        kAll = -1,
        kSRSSeeMjjIn = 0,
        kSRSSemMjjIn,
        kSRSSmmMjjIn,
        kSRSSeeMjjOut,
        kSRSSemMjjOut,
        kSRSSmmMjjOut,
        kSRSS1Jee,
        kSRSS1Jem,
        kSRSS1Jmm,
        kSR0SFOS,
        kSR1SFOS,
        kSR2SFOS,
    };

    SearchMode search_mode;

    // Index of the signal event to read the preferred cut values
    int signal_index;

    // The TTree to hold the signal tree
    TChain* signal_tchain;

};

AnalysisConfig ana;

class CutThresholds
{
public:
    float mjj_window_width;
    float met_pt;
    float mtmax;
    float dphi3lmet;
    float lead_lep_pt;
    int nj30;

    void print_thresholds()
    {
        std::cout <<  " mjj_window_width: " << mjj_window_width <<  std::endl;
        std::cout <<  " met_pt: " << met_pt <<  std::endl;
        std::cout <<  " mtmax: " << mtmax <<  std::endl;
        std::cout <<  " dphi3lmet: " << dphi3lmet <<  std::endl;
        std::cout <<  " lead_lep_pt: " << lead_lep_pt <<  std::endl;
        std::cout <<  " nj30: " << nj30 <<  std::endl;
    }

    void set_thresholds()
    {
        mjj_window_width = fabs(www.Mjj() - 80.);
        met_pt           =      www.met_pt();
        mtmax            =      www.MTmax();
        dphi3lmet        =      www.DPhi3lMET();
        lead_lep_pt      =      www.lep_pt()[0];
        nj30             =      www.nj30();
        print_thresholds();
    }

};

CutThresholds cut_thresh;

// ./process INPUTFILEPATH OUTPUTFILE [NEVENTS]
int main(int argc, char** argv)
{

//********************************************************************************
//
// 1. Parsing options
//
//********************************************************************************

    // cxxopts is just a tool to parse argc, and argv easily

    // Grand option setting
    cxxopts::Options options("\n  $ doAnalysis",  "\n         **********************\n         *                    *\n         *       Looper       *\n         *                    *\n         **********************\n");

    // Read the options
    options.add_options()
        ("i,input"       , "Comma separated input file list OR if just a directory is provided it will glob all in the directory BUT must end with '/' for the path", cxxopts::value<std::string>())
        ("t,tree"        , "Name of the tree in the root file to open and loop over"                                             , cxxopts::value<std::string>())
        ("o,output"      , "Output file name"                                                                                    , cxxopts::value<std::string>())
        ("n,nevents"     , "N events to loop over"                                                                               , cxxopts::value<int>()->default_value("-1"))
        ("m,mode"        , "Search mode"                                                                                         , cxxopts::value<int>()->default_value("-1"))
        ("s,signal_index", "Signal index"                                                                                        , cxxopts::value<int>())
        ("j,nsplit_jobs" , "Enable splitting jobs by N blocks (--job_index must be set)"                                         , cxxopts::value<int>())
        ("I,job_index"   , "job_index of split jobs (--nsplit_jobs must be set. index starts from 0. i.e. 0, 1, 2, 3, etc...)"   , cxxopts::value<int>())
        ("d,debug"       , "Run debug job. i.e. overrides output option to 'debug.root' and 'recreate's the file.")
        ("h,help"        , "Print help")
        ;

    auto result = options.parse(argc, argv);

    // NOTE: When an option was provided (e.g. -i or --input), then the result.count("<option name>") is more than 0
    // Therefore, the option can be parsed easily by asking the condition if (result.count("<option name>");
    // That's how the several options are parsed below

    //_______________________________________________________________________________
    // --help
    if (result.count("help"))
    {
        std::cout << options.help() << std::endl;
        exit(1);
    }

    //_______________________________________________________________________________
    // --input
    if (result.count("input"))
    {
        ana.input_file_list_tstring = result["input"].as<std::string>();
    }
    else
    {
        std::cout << options.help() << std::endl;
        std::cout << "ERROR: Input list is not provided! Check your arguments" << std::endl;
        exit(1);
    }

    //_______________________________________________________________________________
    // --tree
    if (result.count("tree"))
    {
        ana.input_tree_name = result["tree"].as<std::string>();
    }
    else
    {
        std::cout << options.help() << std::endl;
        std::cout << "ERROR: Input tree name is not provided! Check your arguments" << std::endl;
        exit(1);
    }

    //_______________________________________________________________________________
    // --debug
    if (result.count("debug"))
    {
        ana.output_tfile = new TFile("debug.root", "recreate");
    }
    else
    {
        //_______________________________________________________________________________
        // --output
        if (result.count("output"))
        {
            ana.output_tfile = new TFile(result["output"].as<std::string>().c_str(), "create");
            if (not ana.output_tfile->IsOpen())
            {
                std::cout << options.help() << std::endl;
                std::cout << "ERROR: output already exists! provide new output name or delete old file. OUTPUTFILE=" << result["output"].as<std::string>() << std::endl;
                exit(1);
            }
        }
        else
        {
            std::cout << options.help() << std::endl;
            std::cout << "ERROR: Output file name is not provided! Check your arguments" << std::endl;
            exit(1);
        }
    }

    //_______________________________________________________________________________
    // --nevents
    ana.n_events = result["nevents"].as<int>();

    //_______________________________________________________________________________
    // --nevents
    ana.search_mode = static_cast<AnalysisConfig::SearchMode>(result["mode"].as<int>());

    //_______________________________________________________________________________
    // --nsplit_jobs
    if (result.count("nsplit_jobs"))
    {
        ana.nsplit_jobs = result["nsplit_jobs"].as<int>();
        if (ana.nsplit_jobs <= 0)
        {
            std::cout << options.help() << std::endl;
            std::cout << "ERROR: option string --nsplit_jobs" << ana.nsplit_jobs << " has zero or negative value!" << std::endl;
            std::cout << "I am not sure what this means..." << std::endl;
            exit(1);
        }
    }
    else
    {
        ana.nsplit_jobs = -1;
    }

    //_______________________________________________________________________________
    // --signal_index
    if (result.count("signal_index"))
    {
        ana.signal_index = result["signal_index"].as<int>();
        if (ana.signal_index < 0)
        {
            std::cout << options.help() << std::endl;
            std::cout << "ERROR: option string --signal_index" << ana.signal_index << " has negative value!" << std::endl;
            std::cout << "I am not sure what this means..." << std::endl;
            exit(1);
        }
    }
    else
    {
        ana.signal_index = -1;
    }

    //_______________________________________________________________________________
    // --nsplit_jobs
    if (result.count("job_index"))
    {
        ana.job_index = result["job_index"].as<int>();
        if (ana.job_index < 0)
        {
            std::cout << options.help() << std::endl;
            std::cout << "ERROR: option string --job_index" << ana.job_index << " has negative value!" << std::endl;
            std::cout << "I am not sure what this means..." << std::endl;
            exit(1);
        }
    }
    else
    {
        ana.job_index = -1;
    }


    // Sanity check for split jobs (if one is set the other must be set too)
    if (result.count("job_index") or result.count("nsplit_jobs"))
    {
        // If one is not provided then throw error
        if ( not (result.count("job_index") and result.count("nsplit_jobs")))
        {
            std::cout << options.help() << std::endl;
            std::cout << "ERROR: option string --job_index and --nsplit_jobs must be set at the same time!" << std::endl;
            exit(1);
        }
        // If it is set then check for sanity
        else
        {
            if (ana.job_index >= ana.nsplit_jobs)
            {
                std::cout << options.help() << std::endl;
                std::cout << "ERROR: --job_index >= --nsplit_jobs ! This does not make sense..." << std::endl;
                exit(1);
            }
        }
    }

    //
    // Printing out the option settings overview
    //
    std::cout <<  "=========================================================" << std::endl;
    std::cout <<  " Setting of the analysis job based on provided arguments " << std::endl;
    std::cout <<  "---------------------------------------------------------" << std::endl;
    std::cout <<  " ana.input_file_list_tstring: " << ana.input_file_list_tstring <<  std::endl;
    std::cout <<  " ana.output_tfile: " << ana.output_tfile->GetName() <<  std::endl;
    std::cout <<  " ana.n_events: " << ana.n_events <<  std::endl;
    std::cout <<  " ana.nsplit_jobs: " << ana.nsplit_jobs <<  std::endl;
    std::cout <<  " ana.job_index: " << ana.job_index <<  std::endl;
    std::cout <<  "=========================================================" << std::endl;

//=======================================================================
//
// Accessing the signal sample in order to get the desired cut thresholds
//
//=======================================================================

    if (ana.signal_index >= 0)
    {
        TString signal_file_list_tstring = "";

        if (ana.search_mode == AnalysisConfig::kSRSSeeMjjIn)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSeeMjjIn.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSSemMjjIn)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSemMjjIn.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSSmmMjjIn)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSmmMjjIn.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSSeeMjjOut)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSeeMjjOut.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSSemMjjOut)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSemMjjOut.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSSmmMjjOut)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSSmmMjjOut.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSS1Jee)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSS1Jee.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSS1Jem)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSS1Jem.root";
        }

        if (ana.search_mode == AnalysisConfig::kSRSS1Jmm)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SRSS1Jmm.root";
        }

        if (ana.search_mode == AnalysisConfig::kSR0SFOS)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SR0SFOS.root";
        }

        if (ana.search_mode == AnalysisConfig::kSR1SFOS)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SR1SFOS.root";
        }

        if (ana.search_mode == AnalysisConfig::kSR2SFOS)
        {
            signal_file_list_tstring = "/nfs-7/userdata/phchang/WWW_babies/v5.1.9_signal/signal_SR2SFOS.root";
        }

        // Open up the signal tchain
        ana.signal_tchain = RooUtil::FileUtil::createTChain(ana.input_tree_name, signal_file_list_tstring);

        // Check that the requested event number is OK
        if (ana.signal_index >= ana.signal_tchain->GetEntries())
        {
            std::cout << "ERROR: --signal_index >= ana.signal_tchain.GetEntries() ! This does not make sense..." << std::endl;
            exit(1);
        }

        ana.signal_tchain->GetEntry(0);
        www.Init(ana.signal_tchain);
        ana.signal_tchain->LoadTree(ana.signal_index);
        www.GetEntry(ana.signal_index);
        cut_thresh.set_thresholds();

    }

//********************************************************************************
//
// 2. Opening input baby files
//
//********************************************************************************

    // Create the TChain that holds the TTree's of the baby ntuples
    ana.events_tchain = RooUtil::FileUtil::createTChain(ana.input_tree_name, ana.input_file_list_tstring);

    // Create a Looper object to loop over input files
    // the "www" object is defined in the wwwtree.h/cc
    // This is an instance which helps read variables in the WWW baby TTree
    // It is a giant wrapper that facilitates reading TBranch values.
    // e.g. if there is a TBranch named "lep_pt" which is a std::vector<float> then, one can access the branch via
    //
    //    std::vector<float> lep_pt = www.lep_pt();
    //
    // and no need for "SetBranchAddress" and declaring variable shenanigans necessary
    // This is a standard thing SNT does pretty much every looper we use
    ana.looper.init(ana.events_tchain, &www, ana.n_events);

//********************************************************************************
//
// Interlude... notes on RooUtil framework
//
//********************************************************************************

    // ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
    // Quick tutorial on RooUtil::Cutflow object cut tree formation
    // ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
    //
    // The RooUtil::Cutflow object facilitates creating a tree structure of cuts
    //
    // To add cuts to each node of the tree with cuts defined, use "addCut" or "addCutToLastActiveCut"
    // The "addCut" or "addCutToLastActiveCut" accepts three argument, <name>, and two lambda's that define the cut selection, and the weight to apply to that cut stage
    //
    // e.g. To create following cut-tree structure one does
    //
    //             (Root) <--- Always exists as soon as RooUtil::Cutflow object is created. But this is basically hidden underneath and users do not have to care
    //                |
    //            CutWeight
    //            |       |
    //     CutPreSel1    CutPreSel2
    //       |                  |
    //     CutSel1           CutSel2
    //
    //
    //   code:
    //
    //      // Create the object (Root node is created as soon as the instance is created)
    //      RooUtil::Cutflow cutflow;
    //
    //      cutflow.addCut("CutWeight"                 , <lambda> , <lambda>); // CutWeight is added below "Root"-node
    //      cutflow.addCutToLastActiveCut("CutPresel1" , <lambda> , <lambda>); // The last "active" cut is "CutWeight" since I just added that. So "CutPresel1" is added below "CutWeight"
    //      cutflow.addCutToLastActiveCut("CutSel1"    , <lambda> , <lambda>); // The last "active" cut is "CutPresel1" since I just added that. So "CutSel1" is added below "CutPresel1"
    //
    //      cutflow.getCut("CutWeight"); // By "getting" the cut object, this makes the "CutWeight" the last "active" cut.
    //      cutflow.addCutToLastActiveCut("CutPresel2" , <lambda> , <lambda>); // The last "active" cut is "CutWeight" since I "getCut" on it. So "CutPresel2" is added below "CutWeight"
    //      cutflow.addCutToLastActiveCut("CutSel2"    , <lambda> , <lambda>); // The last "active" cut is "CutPresel2" since I just added that. So "CutSel2" is added below "CutPresel1"
    //
    // (Side note: "UNITY" lambda is defined in the framework to just return 1. This so that use don't have to type [&]() {return 1;} so many times.)
    //
    // Once the cutflow is formed, create cutflow histograms can be created by calling RooUtil::Cutflow::bookCutflows())
    // This function looks through the terminating nodes of the tree structured cut tree. and creates a histogram that will fill the yields
    // For the example above, there are two terminationg nodes, "CutSel1", and "CutSel2"
    // So in this case Root::Cutflow::bookCutflows() will create two histograms. (Actually four histograms.)
    //
    //  - TH1F* type object :  CutSel1_cutflow (4 bins, with first bin labeled "Root", second bin labeled "CutWeight", third bin labeled "CutPreSel1", fourth bin labeled "CutSel1")
    //  - TH1F* type object :  CutSel2_cutflow (...)
    //  - TH1F* type object :  CutSel1_rawcutflow (...)
    //  - TH1F* type object :  CutSel2_rawcutflow (...)
    //                                ^
    //                                |
    // NOTE: There is only one underscore "_" between <CutName>_cutflow or <CutName>_rawcutflow
    //
    // And later in the loop when RooUtil::Cutflow::fill() function is called, the tree structure will be traversed through and the appropriate yields will be filled into the histograms
    //
    // After running the loop check for the histograms in the output root file

    // ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
    // Quick tutorial on RooUtil::Histograms object
    // ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
    //
    // The RooUtil::Histograms object facilitates book keeping histogram definitions
    // And in conjunction with RooUtil::Cutflow object, one can book same histograms across different cut stages easily without copy pasting codes many times by hand.
    //
    // The histogram addition happens in two steps.
    // 1. Defining histograms
    // 2. Booking histograms to cuts
    //
    // Histograms are defined via following functions
    //
    //      RooUtil::Histograms::addHistogram       : Typical 1D histogram (TH1F*) "Fill()" called once per event
    //      RooUtil::Histograms::addVecHistogram    : Typical 1D histogram (TH1F*) "Fill()" called multiple times per event
    //      RooUtil::Histograms::add2DHistogram     : Typical 2D histogram (TH2F*) "Fill()" called once per event
    //      RooUtil::Histograms::add2DVecHistogram  : Typical 2D histogram (TH2F*) "Fill()" called multiple times per event
    // e.g.
    //
    //    RooUtil::Histograms histograms;
    //    histograms.addHistogram   ("MllSS"    , 180 , 0. , 300. , [&]() { return www.MllSS()  ; }); // The lambda returns float
    //    histograms.addVecHistogram("AllLepPt" , 180 , 0. , 300. , [&]() { return www.lep_pt() ; }); // The lambda returns vector<float>
    //
    // The addVecHistogram will have lambda to return vector<float> and it will loop over the values and call TH1F::Fill() for each item
    //
    // To book histograms to cuts one uses
    //
    //      RooUtil::Cutflow::bookHistogramsForCut()
    //      RooUtil::Cutflow::bookHistogramsForCutAndBelow()
    //      RooUtil::Cutflow::bookHistogramsForCutAndAbove()
    //      RooUtil::Cutflow::bookHistogramsForEndCuts()
    //
    // e.g. Given a tree like the following, we can book histograms to various cuts as we want
    //
    //              Root
    //                |
    //            CutWeight
    //            |       |
    //     CutPreSel1    CutPreSel2
    //       |                  |
    //     CutSel1           CutSel2
    //
    // For example,
    //
    //    1. book a set of histograms to one cut:
    //
    //       cutflow.bookHistogramsForCut(histograms, "CutPreSel2")
    //
    //    2. book a set of histograms to a cut and below
    //
    //       cutflow.bookHistogramsForCutAndBelow(histograms, "CutWeight") // will book a set of histograms to CutWeight, CutPreSel1, CutPreSel2, CutSel1, and CutSel2
    //
    //    3. book a set of histograms to a cut and above (... useless...?)
    //
    //       cutflow.bookHistogramsForCutAndAbove(histograms, "CutPreSel2") // will book a set of histograms to CutPreSel2, CutWeight (nothing happens to Root node)
    //
    //    4. book a set of histograms to a terminating nodes
    //
    //       cutflow.bookHistogramsForEndCuts(histograms) // will book a set of histograms to CutSel1 and CutSel2
    //
    // The naming convention of the booked histograms are as follows
    //
    //   cutflow.bookHistogramsForCut(histograms, "CutSel1");
    //
    //  - TH1F* type object : CutSel1__MllSS;
    //  - TH1F* type object : CutSel1__AllLepPt;
    //                               ^^
    //                               ||
    // NOTE: There are two underscores "__" between <CutName>__<HistogramName>
    //
    // And later in the loop when RooUtil::CutName::fill() function is called, the tree structure will be traversed through and the appropriate histograms will be filled with appropriate variables
    // After running the loop check for the histograms in the output root file


    // Set the cutflow object output file
    ana.cutflow.setTFile(ana.output_tfile);

    ana.cutflow.addCut("SRSSeeMjjInFull", [&]() { return www.SRSSeeMjjInFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSSemMjjInFull", [&]() { return www.SRSSemMjjInFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSSmmMjjInFull", [&]() { return www.SRSSmmMjjInFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSSeeMjjOutFull", [&]() { return www.SRSSeeMjjOutFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSSemMjjOutFull", [&]() { return www.SRSSemMjjOutFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSSmmMjjOutFull", [&]() { return www.SRSSmmMjjOutFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSS1JeeFull", [&]() { return www.SRSS1JeeFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSS1JemFull", [&]() { return www.SRSS1JemFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSS1JmmFull", [&]() { return www.SRSS1JmmFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SR0SFOSFull", [&]() { return www.SR0SFOSFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SR1SFOSFull", [&]() { return www.SR1SFOSFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SR2SFOSFull", [&]() { return www.SR2SFOSFull(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );

    ana.cutflow.addCut("SRSSee", [&]() { return www.SRSSee(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSSem", [&]() { return www.SRSSem(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SRSSmm", [&]() { return www.SRSSmm(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SR0SFOS", [&]() { return www.SR0SFOS(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SR1SFOS", [&]() { return www.SR1SFOS(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );
    ana.cutflow.addCut("SR2SFOS", [&]() { return www.SR2SFOS(); }, [&]() { return www.event_weight() * www.lepton_scale_factor() * www.btag_scale_factor() * www.trigger_scale_factor(); } );

    if (ana.search_mode == AnalysisConfig::kSRSSeeMjjIn or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSee");
        ana.cutflow.addCutToLastActiveCut("SRSSeeNj2", [&]() { return www.nj30() >= 2; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SRSSeeNb0", [&]() { return www.nb() == 0; }, UNITY);
    }

    if (ana.search_mode == AnalysisConfig::kSRSSemMjjIn or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSem");
        ana.cutflow.addCutToLastActiveCut("SRSSemNj2", [&]() { return www.nj30() >= 2; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SRSSemNb0", [&]() { return www.nb() == 0; }, UNITY);
    }

    if (ana.search_mode == AnalysisConfig::kSRSSmmMjjIn or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSmm");
        ana.cutflow.addCutToLastActiveCut("SRSSmmNj2", [&]() { return www.nj30() >= 2; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SRSSmmNb0", [&]() { return www.nb() == 0; }, UNITY);
    }

    if (ana.search_mode == AnalysisConfig::kSRSSeeMjjOut or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSee");
    }

    if (ana.search_mode == AnalysisConfig::kSRSSemMjjOut or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSem");
    }

    if (ana.search_mode == AnalysisConfig::kSRSSmmMjjOut or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSmm");
    }

    if (ana.search_mode == AnalysisConfig::kSRSS1Jee or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSee");
    }

    if (ana.search_mode == AnalysisConfig::kSRSS1Jem or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSem");
    }

    if (ana.search_mode == AnalysisConfig::kSRSS1Jmm or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SRSSmm");
    }

    if (ana.search_mode == AnalysisConfig::kSR0SFOS or ana.search_mode == AnalysisConfig::kAll)
    {
        ana.cutflow.getCut("SR0SFOS");
        ana.cutflow.addCutToLastActiveCut("SR0SFOSNb0"       , [&]() { return www.nb() == 0; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SR0SFOSNj"        , [&]() { return www.nj30() <= cut_thresh.nj30; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SR0SFOSLepPt0"    , [&]() { return www.lep_pt()[0] >= cut_thresh.lead_lep_pt; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SR0SFOSMET"       , [&]() { return www.met_pt() >= cut_thresh.met_pt; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SR0SFOSDPhi3LMET" , [&]() { return www.DPhi3lMET() >= cut_thresh.dphi3lmet; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SR0SFOSMTmax"     , [&]() { return www.MTmax() >= cut_thresh.mtmax; }, UNITY);
        ana.cutflow.addCutToLastActiveCut("SR0SFOSOptFull"   , UNITY, UNITY);
    }

    if (ana.search_mode == ana.kSR1SFOS or ana.search_mode == ana.kAll)
    {
        ana.cutflow.getCut("SR1SFOS");
    }

    if (ana.search_mode == ana.kSR2SFOS or ana.search_mode == ana.kAll)
    {
        ana.cutflow.getCut("SR2SFOS");
    }

    // Print cut structure
    ana.cutflow.printCuts();

    // Histogram utility object that is used to define the histograms
    ana.histograms.addHistogram("nj", 7, 0, 7, [&]() { return www.nj(); } );
    ana.histograms.addHistogram("nj30", 7, 0, 7, [&]() { return www.nj30(); } );
    ana.histograms.addHistogram("Mjj", 180, 0, 300, [&]() { return www.Mjj(); } );

    // Book cutflows
    ana.cutflow.bookCutflows();

    // Book Histograms
    // ana.cutflow.bookHistogramsForCutAndBelow(ana.histograms, "DiElChannel");
    // ana.cutflow.bookHistogramsForCutAndBelow(ana.histograms, "DiMuChannel");
    ana.cutflow.bookHistograms(ana.histograms); // if just want to book everywhere

    // Looping input file
    while (ana.looper.nextEvent())
    {

        // If splitting jobs are requested then determine whether to process the event or not based on remainder
        if (result.count("job_index") and result.count("nsplit_jobs"))
        {
            if (ana.looper.getNEventsProcessed() % ana.nsplit_jobs != (unsigned int) ana.job_index)
                continue;
        }

        //Do what you need to do in for each event here
        //To save use the following function
        ana.cutflow.fill();
    }

    // Writing output file
    ana.cutflow.saveOutput();

    // The below can be sometimes crucial
    delete ana.output_tfile;
}
