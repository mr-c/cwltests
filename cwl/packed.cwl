{
    "cwlVersion": "v1.0", 
    "$graph": [
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "ScatterFeatureRequirement"
                }, 
                {
                    "class": "SubworkflowFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "default": [
                        "mc1", 
                        "mc2"
                    ], 
                    "id": "#main/all_bkg_mc_mcnames"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "float"
                    }, 
                    "default": [
                        0.01875, 
                        0.0125
                    ], 
                    "id": "#main/all_bkg_mc_mcweights"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "int"
                    }, 
                    "default": [
                        20000, 
                        20000, 
                        20000, 
                        20000, 
                        20000, 
                        20000, 
                        20000, 
                        20000
                    ], 
                    "id": "#main/all_bkg_mc_nevents"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "int"
                    }, 
                    "default": [
                        10000, 
                        10000, 
                        10000, 
                        10000, 
                        10000, 
                        10000, 
                        10000, 
                        10000, 
                        10000, 
                        10000
                    ], 
                    "id": "#main/data_nevents"
                }, 
                {
                    "type": "float", 
                    "default": 0.0025, 
                    "id": "#main/signal_mcweight"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "int"
                    }, 
                    "default": [
                        20000, 
                        20000, 
                        20000, 
                        20000
                    ], 
                    "id": "#main/signal_nevents"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputSource": "#main/hepdata/hepdata_submission", 
                    "id": "#main/hepdata_submission"
                }, 
                {
                    "type": "File", 
                    "outputSource": "#main/plot/postfit_report", 
                    "id": "#main/postfit_report"
                }, 
                {
                    "type": "File", 
                    "outputSource": "#main/plot/prefit_report", 
                    "id": "#main/prefit_report"
                }
            ], 
            "steps": [
                {
                    "run": "#wflow_all_mc.cwl", 
                    "in": [
                        {
                            "source": "#main/all_bkg_mc_mcnames", 
                            "id": "#main/all_bkg_mc/mcnames"
                        }, 
                        {
                            "source": "#main/all_bkg_mc_mcweights", 
                            "id": "#main/all_bkg_mc/mcweights"
                        }, 
                        {
                            "source": "#main/all_bkg_mc_nevents", 
                            "id": "#main/all_bkg_mc/nevents"
                        }
                    ], 
                    "out": [
                        "#main/all_bkg_mc/merged"
                    ], 
                    "id": "#main/all_bkg_mc"
                }, 
                {
                    "run": "#workflow_data.cwl", 
                    "in": [
                        {
                            "source": "#main/data_nevents", 
                            "id": "#main/data/nevents"
                        }
                    ], 
                    "out": [
                        "#main/data/merged"
                    ], 
                    "id": "#main/data"
                }, 
                {
                    "run": "#hepdata.cwl", 
                    "in": [
                        {
                            "source": "#main/makews/workspace", 
                            "id": "#main/hepdata/combined_model"
                        }
                    ], 
                    "out": [
                        "#main/hepdata/hepdata_submission"
                    ], 
                    "id": "#main/hepdata"
                }, 
                {
                    "run": "#makews.cwl", 
                    "in": [
                        {
                            "source": "#main/merge/merged", 
                            "id": "#main/makews/data_bkg_hists"
                        }
                    ], 
                    "out": [
                        "#main/makews/workspace"
                    ], 
                    "id": "#main/makews"
                }, 
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": [
                                "#main/all_bkg_mc/merged", 
                                "#main/data/merged", 
                                "#main/signal/merged"
                            ], 
                            "id": "#main/merge/histograms"
                        }
                    ], 
                    "out": [
                        "#main/merge/merged"
                    ], 
                    "id": "#main/merge"
                }, 
                {
                    "run": "#plot.cwl", 
                    "in": [
                        {
                            "source": "#main/makews/workspace", 
                            "id": "#main/plot/combined_model"
                        }
                    ], 
                    "out": [
                        "#main/plot/prefit_report", 
                        "#main/plot/postfit_report"
                    ], 
                    "id": "#main/plot"
                }, 
                {
                    "run": "#workflow_sig.cwl", 
                    "in": [
                        {
                            "source": "#main/signal_mcweight", 
                            "id": "#main/signal/mcweight"
                        }, 
                        {
                            "source": "#main/signal_nevents", 
                            "id": "#main/signal/nevents"
                        }
                    ], 
                    "out": [
                        "#main/signal/merged"
                    ], 
                    "id": "#main/signal"
                }
            ], 
            "id": "#main"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "int", 
                    "id": "#generate.cwl/nevents"
                }, 
                {
                    "type": "string", 
                    "id": "#generate.cwl/type"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "output_one.root"
                    }, 
                    "id": "#generate.cwl/events"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "valueFrom": "source /usr/local/bin/thisroot.sh\npython /code/generantuple.py $(inputs.type) $(inputs.nevents) output_one.root\n", 
                    "prefix": "-c"
                }
            ], 
            "id": "#generate.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "File", 
                    "id": "#hepdata.cwl/combined_model"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "submission.zip"
                    }, 
                    "id": "#hepdata.cwl/hepdata_submission"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "prefix": "-c", 
                    "valueFrom": "source /usr/local/bin/thisroot.sh\npython /code/hepdata_export.py $(inputs.combined_model.path)\nzip submission.zip submission.yaml data1.yaml\n"
                }
            ], 
            "id": "#hepdata.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "File", 
                    "id": "#histogram.cwl/inputfile"
                }, 
                {
                    "type": "string", 
                    "id": "#histogram.cwl/name"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "default": [
                        "nominal"
                    ], 
                    "id": "#histogram.cwl/variations"
                }, 
                {
                    "type": "float", 
                    "id": "#histogram.cwl/weight"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "hist.root"
                    }, 
                    "id": "#histogram.cwl/histogram"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "prefix": "-c", 
                    "valueFrom": "source /usr/local/bin/thisroot.sh\npython /code/histogram.py $(inputs.inputfile.path) hist.root $(inputs.name) $(inputs.weight) ${\n  var list=\"\";\n  var variationsLength = inputs.variations.length;\n  console.log(variationsLength);\n  for (var i = 0; i < variationsLength; i++) {\n    list += inputs.variations[i];\n    if (i < variationsLength - 1) {\n      list = list +\",\";\n    }\n  }\n  return list; }\n"
                }
            ], 
            "id": "#histogram.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "File", 
                    "id": "#histogram_shape.cwl/inputfile"
                }, 
                {
                    "type": "string", 
                    "id": "#histogram_shape.cwl/name"
                }, 
                {
                    "type": "string", 
                    "id": "#histogram_shape.cwl/shapevar"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "id": "#histogram_shape.cwl/variations"
                }, 
                {
                    "type": "float", 
                    "id": "#histogram_shape.cwl/weight"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "hist.root"
                    }, 
                    "id": "#histogram_shape.cwl/histogram"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "prefix": "-c", 
                    "valueFrom": "source /usr/local/bin/thisroot.sh\npython /code/histogram.py $(inputs.inputfile.path) hist.root $(inputs.name)_$(inputs.shapevar) $(inputs.weight) ${\n  var list=\"\";\n  var variationsLength = inputs.variations.length;\n  console.log(variationsLength);\n  for (var i = 0; i < variationsLength; i++) {\n    list += inputs.variations[i];\n    if (i < variationsLength - 1) {\n      list = list +\",\";\n    }\n  }\n  return list; } {name}\n"
                }
            ], 
            "id": "#histogram_shape.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "File", 
                    "id": "#makews.cwl/data_bkg_hists"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "workspace*combined*model.root"
                    }, 
                    "id": "#makews.cwl/workspace"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "prefix": "-c", 
                    "valueFrom": "source /usr/local/bin/thisroot.sh\npython /code/makews.py $(inputs.data_bkg_hists.path) $(runtime.outdir)/workspace $(runtime.outdir)/xml\n"
                }
            ], 
            "id": "#makews.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }, 
                {
                    "listing": [
                        {
                            "entryname": "input_list", 
                            "entry": "${ var list = \"\";\n   inputs.histograms.forEach(function(value)  {\n     list += value.path + '\\n';\n     });\n   return list; }\n"
                        }
                    ], 
                    "class": "InitialWorkDirRequirement"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "id": "#merge.cwl/histograms"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "merged.root"
                    }, 
                    "id": "#merge.cwl/merged"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "valueFrom": "source /usr/local/bin/thisroot.sh\ncat $(runtime.outdir)/input_list | xargs hadd merged.root\n", 
                    "prefix": "-c"
                }
            ], 
            "id": "#merge.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "File", 
                    "id": "#plot.cwl/combined_model"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "postfit.pdf"
                    }, 
                    "id": "#plot.cwl/postfit_report"
                }, 
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "prefit.pdf"
                    }, 
                    "id": "#plot.cwl/prefit_report"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "prefix": "-c", 
                    "valueFrom": "source /usr/local/bin/thisroot.sh\nhfquickplot write_vardef $(inputs.combined_model.path) combined nominal_vals.yml\nhfquickplot plot_channel $(inputs.combined_model.path) combined channel1 x nominal_vals.yml -c qcd,mc2,mc1,signal -o prefit.pdf\nhfquickplot fit $(inputs.combined_model.path) combined fitresults.yml\nhfquickplot plot_channel $(inputs.combined_model.path) combined channel1 x fitresults.yml -c qcd,mc2,mc1,signal -o postfit.pdf\n"
                }
            ], 
            "id": "#plot.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "dockerPull": "lukasheinrich/dummyanalysis", 
                    "class": "DockerRequirement"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "File", 
                    "id": "#select.cwl/inputfile"
                }, 
                {
                    "type": "string", 
                    "id": "#select.cwl/region"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "id": "#select.cwl/variations"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputBinding": {
                        "glob": "selection.root"
                    }, 
                    "id": "#select.cwl/outputfile"
                }
            ], 
            "baseCommand": "/bin/bash", 
            "arguments": [
                {
                    "prefix": "-c", 
                    "valueFrom": "source /usr/local/bin/thisroot.sh\npython /code/select.py $(inputs.inputfile.path) selection.root $(inputs.region) ${\n   var list=\"\";\n   var variationsLength = inputs.variations.length;\n   console.log(variationsLength);\n   for (var i = 0; i < variationsLength; i++) {\n     list += inputs.variations[i];\n     if (i < variationsLength - 1) {\n       list = list +\",\";\n     }\n   }\n   return list; }\n"
                }
            ], 
            "id": "#select.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "ScatterFeatureRequirement"
                }, 
                {
                    "class": "SubworkflowFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "id": "#wflow_all_mc.cwl/mcnames"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "float"
                    }, 
                    "id": "#wflow_all_mc.cwl/mcweights"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "int"
                    }, 
                    "id": "#wflow_all_mc.cwl/nevents"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "default": [
                        "shape_conv_up", 
                        "shape_conv_dn"
                    ], 
                    "id": "#wflow_all_mc.cwl/shapevars"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "default": [
                        "nominal", 
                        "weight_var1_up", 
                        "weight_var1_dn"
                    ], 
                    "id": "#wflow_all_mc.cwl/weightvariations"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputSource": "#wflow_all_mc.cwl/merge/merged", 
                    "id": "#wflow_all_mc.cwl/merged"
                }
            ], 
            "steps": [
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": "#wflow_all_mc.cwl/run_mc/merged", 
                            "id": "#wflow_all_mc.cwl/merge/histograms"
                        }
                    ], 
                    "out": [
                        "#wflow_all_mc.cwl/merge/merged"
                    ], 
                    "id": "#wflow_all_mc.cwl/merge"
                }, 
                {
                    "run": "#workflow_mc.cwl", 
                    "in": [
                        {
                            "source": "#wflow_all_mc.cwl/mcnames", 
                            "id": "#wflow_all_mc.cwl/run_mc/mcname"
                        }, 
                        {
                            "source": "#wflow_all_mc.cwl/mcweights", 
                            "id": "#wflow_all_mc.cwl/run_mc/mcweight"
                        }, 
                        {
                            "source": "#wflow_all_mc.cwl/nevents", 
                            "id": "#wflow_all_mc.cwl/run_mc/nevents"
                        }, 
                        {
                            "source": "#wflow_all_mc.cwl/shapevars", 
                            "id": "#wflow_all_mc.cwl/run_mc/shapevars"
                        }, 
                        {
                            "source": "#wflow_all_mc.cwl/weightvariations", 
                            "id": "#wflow_all_mc.cwl/run_mc/weightvariations"
                        }
                    ], 
                    "scatter": [
                        "#wflow_all_mc.cwl/run_mc/mcname", 
                        "#wflow_all_mc.cwl/run_mc/mcweight"
                    ], 
                    "scatterMethod": "dotproduct", 
                    "out": [
                        "#wflow_all_mc.cwl/run_mc/merged"
                    ], 
                    "id": "#wflow_all_mc.cwl/run_mc"
                }
            ], 
            "id": "#wflow_all_mc.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "ScatterFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": {
                        "type": "array", 
                        "items": "int"
                    }, 
                    "id": "#workflow_data.cwl/nevents"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputSource": "#workflow_data.cwl/merge_all/merged", 
                    "id": "#workflow_data.cwl/merged"
                }
            ], 
            "steps": [
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": "#workflow_data.cwl/read/events", 
                            "id": "#workflow_data.cwl/merge/histograms"
                        }
                    ], 
                    "out": [
                        "#workflow_data.cwl/merge/merged"
                    ], 
                    "id": "#workflow_data.cwl/merge"
                }, 
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": [
                                "#workflow_data.cwl/select_signal_hist/histogram", 
                                "#workflow_data.cwl/select_control_hist/histogram"
                            ], 
                            "id": "#workflow_data.cwl/merge_all/histograms"
                        }
                    ], 
                    "out": [
                        "#workflow_data.cwl/merge_all/merged"
                    ], 
                    "id": "#workflow_data.cwl/merge_all"
                }, 
                {
                    "run": "#generate.cwl", 
                    "in": [
                        {
                            "source": "#workflow_data.cwl/nevents", 
                            "id": "#workflow_data.cwl/read/nevents"
                        }, 
                        {
                            "default": "data", 
                            "id": "#workflow_data.cwl/read/type"
                        }
                    ], 
                    "scatter": "#workflow_data.cwl/read/nevents", 
                    "out": [
                        "#workflow_data.cwl/read/events"
                    ], 
                    "id": "#workflow_data.cwl/read"
                }, 
                {
                    "run": "#select.cwl", 
                    "in": [
                        {
                            "source": "#workflow_data.cwl/merge/merged", 
                            "id": "#workflow_data.cwl/select_control/inputfile"
                        }, 
                        {
                            "default": "control", 
                            "id": "#workflow_data.cwl/select_control/region"
                        }, 
                        {
                            "default": [
                                "nominal"
                            ], 
                            "id": "#workflow_data.cwl/select_control/variations"
                        }
                    ], 
                    "out": [
                        "#workflow_data.cwl/select_control/outputfile"
                    ], 
                    "id": "#workflow_data.cwl/select_control"
                }, 
                {
                    "run": "#histogram.cwl", 
                    "in": [
                        {
                            "source": "#workflow_data.cwl/select_control/outputfile", 
                            "id": "#workflow_data.cwl/select_control_hist/inputfile"
                        }, 
                        {
                            "default": "qcd", 
                            "id": "#workflow_data.cwl/select_control_hist/name"
                        }, 
                        {
                            "default": 0.1875, 
                            "id": "#workflow_data.cwl/select_control_hist/weight"
                        }
                    ], 
                    "out": [
                        "#workflow_data.cwl/select_control_hist/histogram"
                    ], 
                    "id": "#workflow_data.cwl/select_control_hist"
                }, 
                {
                    "run": "#select.cwl", 
                    "in": [
                        {
                            "source": "#workflow_data.cwl/merge/merged", 
                            "id": "#workflow_data.cwl/select_signal/inputfile"
                        }, 
                        {
                            "default": "signal", 
                            "id": "#workflow_data.cwl/select_signal/region"
                        }, 
                        {
                            "default": [
                                "nominal"
                            ], 
                            "id": "#workflow_data.cwl/select_signal/variations"
                        }
                    ], 
                    "out": [
                        "#workflow_data.cwl/select_signal/outputfile"
                    ], 
                    "id": "#workflow_data.cwl/select_signal"
                }, 
                {
                    "run": "#histogram.cwl", 
                    "in": [
                        {
                            "source": "#workflow_data.cwl/select_signal/outputfile", 
                            "id": "#workflow_data.cwl/select_signal_hist/inputfile"
                        }, 
                        {
                            "default": "data", 
                            "id": "#workflow_data.cwl/select_signal_hist/name"
                        }, 
                        {
                            "default": 1.0, 
                            "id": "#workflow_data.cwl/select_signal_hist/weight"
                        }
                    ], 
                    "out": [
                        "#workflow_data.cwl/select_signal_hist/histogram"
                    ], 
                    "id": "#workflow_data.cwl/select_signal_hist"
                }
            ], 
            "id": "#workflow_data.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "ScatterFeatureRequirement"
                }, 
                {
                    "class": "SubworkflowFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "string", 
                    "id": "#workflow_mc.cwl/mcname"
                }, 
                {
                    "type": "float", 
                    "id": "#workflow_mc.cwl/mcweight"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "int"
                    }, 
                    "id": "#workflow_mc.cwl/nevents"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "id": "#workflow_mc.cwl/shapevars"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }, 
                    "id": "#workflow_mc.cwl/weightvariations"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputSource": "#workflow_mc.cwl/merge_all_vars/merged", 
                    "id": "#workflow_mc.cwl/merged"
                }
            ], 
            "steps": [
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": "#workflow_mc.cwl/read/events", 
                            "id": "#workflow_mc.cwl/merge/histograms"
                        }
                    ], 
                    "out": [
                        "#workflow_mc.cwl/merge/merged"
                    ], 
                    "id": "#workflow_mc.cwl/merge"
                }, 
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": [
                                "#workflow_mc.cwl/select_signal_hist/histogram", 
                                "#workflow_mc.cwl/merge_shape/merged"
                            ], 
                            "id": "#workflow_mc.cwl/merge_all_vars/histograms"
                        }
                    ], 
                    "out": [
                        "#workflow_mc.cwl/merge_all_vars/merged"
                    ], 
                    "id": "#workflow_mc.cwl/merge_all_vars"
                }, 
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": "#workflow_mc.cwl/select_signal_shapevars/histogram", 
                            "id": "#workflow_mc.cwl/merge_shape/histograms"
                        }
                    ], 
                    "out": [
                        "#workflow_mc.cwl/merge_shape/merged"
                    ], 
                    "id": "#workflow_mc.cwl/merge_shape"
                }, 
                {
                    "run": "#generate.cwl", 
                    "in": [
                        {
                            "source": "#workflow_mc.cwl/nevents", 
                            "id": "#workflow_mc.cwl/read/nevents"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/mcname", 
                            "id": "#workflow_mc.cwl/read/type"
                        }
                    ], 
                    "scatter": "#workflow_mc.cwl/read/nevents", 
                    "out": [
                        "#workflow_mc.cwl/read/events"
                    ], 
                    "id": "#workflow_mc.cwl/read"
                }, 
                {
                    "run": "#select.cwl", 
                    "in": [
                        {
                            "source": "#workflow_mc.cwl/merge/merged", 
                            "id": "#workflow_mc.cwl/select_signal/inputfile"
                        }, 
                        {
                            "default": "signal", 
                            "id": "#workflow_mc.cwl/select_signal/region"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/weightvariations", 
                            "id": "#workflow_mc.cwl/select_signal/variations"
                        }
                    ], 
                    "out": [
                        "#workflow_mc.cwl/select_signal/outputfile"
                    ], 
                    "id": "#workflow_mc.cwl/select_signal"
                }, 
                {
                    "run": "#histogram.cwl", 
                    "in": [
                        {
                            "source": "#workflow_mc.cwl/select_signal/outputfile", 
                            "id": "#workflow_mc.cwl/select_signal_hist/inputfile"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/mcname", 
                            "id": "#workflow_mc.cwl/select_signal_hist/name"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/weightvariations", 
                            "id": "#workflow_mc.cwl/select_signal_hist/variations"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/mcweight", 
                            "id": "#workflow_mc.cwl/select_signal_hist/weight"
                        }
                    ], 
                    "out": [
                        "#workflow_mc.cwl/select_signal_hist/histogram"
                    ], 
                    "id": "#workflow_mc.cwl/select_signal_hist"
                }, 
                {
                    "run": "#workflow_select_shape.cwl", 
                    "in": [
                        {
                            "source": "#workflow_mc.cwl/merge/merged", 
                            "id": "#workflow_mc.cwl/select_signal_shapevars/inputfile"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/mcname", 
                            "id": "#workflow_mc.cwl/select_signal_shapevars/mcname"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/mcweight", 
                            "id": "#workflow_mc.cwl/select_signal_shapevars/mcweight"
                        }, 
                        {
                            "source": "#workflow_mc.cwl/shapevars", 
                            "id": "#workflow_mc.cwl/select_signal_shapevars/shapevar"
                        }
                    ], 
                    "out": [
                        "#workflow_mc.cwl/select_signal_shapevars/histogram"
                    ], 
                    "scatter": "#workflow_mc.cwl/select_signal_shapevars/shapevar", 
                    "id": "#workflow_mc.cwl/select_signal_shapevars"
                }
            ], 
            "id": "#workflow_mc.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "ScatterFeatureRequirement"
                }, 
                {
                    "class": "StepInputExpressionRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "File", 
                    "id": "#workflow_select_shape.cwl/inputfile"
                }, 
                {
                    "type": "string", 
                    "id": "#workflow_select_shape.cwl/mcname"
                }, 
                {
                    "type": "float", 
                    "id": "#workflow_select_shape.cwl/mcweight"
                }, 
                {
                    "type": "string", 
                    "id": "#workflow_select_shape.cwl/shapevar"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputSource": "#workflow_select_shape.cwl/hist/histogram", 
                    "id": "#workflow_select_shape.cwl/histogram"
                }
            ], 
            "steps": [
                {
                    "run": "#histogram_shape.cwl", 
                    "in": [
                        {
                            "source": "#workflow_select_shape.cwl/select/outputfile", 
                            "id": "#workflow_select_shape.cwl/hist/inputfile"
                        }, 
                        {
                            "source": "#workflow_select_shape.cwl/mcname", 
                            "id": "#workflow_select_shape.cwl/hist/name"
                        }, 
                        {
                            "source": "#workflow_select_shape.cwl/shapevar", 
                            "id": "#workflow_select_shape.cwl/hist/shapevar"
                        }, 
                        {
                            "default": [
                                "nominal"
                            ], 
                            "id": "#workflow_select_shape.cwl/hist/variations"
                        }, 
                        {
                            "source": "#workflow_select_shape.cwl/mcweight", 
                            "id": "#workflow_select_shape.cwl/hist/weight"
                        }
                    ], 
                    "out": [
                        "#workflow_select_shape.cwl/hist/histogram"
                    ], 
                    "id": "#workflow_select_shape.cwl/hist"
                }, 
                {
                    "run": "#select.cwl", 
                    "in": [
                        {
                            "source": "#workflow_select_shape.cwl/inputfile", 
                            "id": "#workflow_select_shape.cwl/select/inputfile"
                        }, 
                        {
                            "default": "signal", 
                            "id": "#workflow_select_shape.cwl/select/region"
                        }, 
                        {
                            "source": "#workflow_select_shape.cwl/shapevar", 
                            "valueFrom": "${ return [ self ]; }", 
                            "id": "#workflow_select_shape.cwl/select/variations"
                        }
                    ], 
                    "out": [
                        "#workflow_select_shape.cwl/select/outputfile"
                    ], 
                    "id": "#workflow_select_shape.cwl/select"
                }
            ], 
            "id": "#workflow_select_shape.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "ScatterFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "type": "float", 
                    "id": "#workflow_sig.cwl/mcweight"
                }, 
                {
                    "type": {
                        "type": "array", 
                        "items": "int"
                    }, 
                    "id": "#workflow_sig.cwl/nevents"
                }
            ], 
            "outputs": [
                {
                    "type": "File", 
                    "outputSource": "#workflow_sig.cwl/select_hist/histogram", 
                    "id": "#workflow_sig.cwl/merged"
                }
            ], 
            "steps": [
                {
                    "run": "#merge.cwl", 
                    "in": [
                        {
                            "source": "#workflow_sig.cwl/read/events", 
                            "id": "#workflow_sig.cwl/merge/histograms"
                        }
                    ], 
                    "out": [
                        "#workflow_sig.cwl/merge/merged"
                    ], 
                    "id": "#workflow_sig.cwl/merge"
                }, 
                {
                    "run": "#generate.cwl", 
                    "in": [
                        {
                            "source": "#workflow_sig.cwl/nevents", 
                            "id": "#workflow_sig.cwl/read/nevents"
                        }, 
                        {
                            "default": "sig", 
                            "id": "#workflow_sig.cwl/read/type"
                        }
                    ], 
                    "scatter": "#workflow_sig.cwl/read/nevents", 
                    "out": [
                        "#workflow_sig.cwl/read/events"
                    ], 
                    "id": "#workflow_sig.cwl/read"
                }, 
                {
                    "run": "#select.cwl", 
                    "in": [
                        {
                            "source": "#workflow_sig.cwl/merge/merged", 
                            "id": "#workflow_sig.cwl/select/inputfile"
                        }, 
                        {
                            "default": "signal", 
                            "id": "#workflow_sig.cwl/select/region"
                        }, 
                        {
                            "default": [
                                "nominal"
                            ], 
                            "id": "#workflow_sig.cwl/select/variations"
                        }
                    ], 
                    "out": [
                        "#workflow_sig.cwl/select/outputfile"
                    ], 
                    "id": "#workflow_sig.cwl/select"
                }, 
                {
                    "run": "#histogram.cwl", 
                    "in": [
                        {
                            "source": "#workflow_sig.cwl/select/outputfile", 
                            "id": "#workflow_sig.cwl/select_hist/inputfile"
                        }, 
                        {
                            "default": "signal", 
                            "id": "#workflow_sig.cwl/select_hist/name"
                        }, 
                        {
                            "source": "#workflow_sig.cwl/mcweight", 
                            "id": "#workflow_sig.cwl/select_hist/weight"
                        }
                    ], 
                    "out": [
                        "#workflow_sig.cwl/select_hist/histogram"
                    ], 
                    "id": "#workflow_sig.cwl/select_hist"
                }
            ], 
            "id": "#workflow_sig.cwl"
        }
    ]
}