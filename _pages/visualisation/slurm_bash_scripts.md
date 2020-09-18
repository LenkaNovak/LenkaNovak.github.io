---
title: "SLURM Bash Scripts"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: visualisation
---

These are examples of useful scripts for visualising output from `ClimateMachine.jl`

## End-to-end modelling
### Scripts

- [Run LES experiment and plot some output](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts)
- [Set up multi-experiment GCM runs with performance info tracking on GPU](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts#step-by-step)

### Demos

- [Basic GCM: run and plot](https://lenkanovak.github.io/_pages/visualisation/demo_basic_gcm/)
- [Output and plot the last timestep before crashing](https://lenkanovak.github.io/_pages/visualisation/demo_debug_gcm/)
- [Run multiple experiments and plot their differences](https://lenkanovak.github.io/_pages/visualisation/demo_basic_multi_gcm/)

NB: these demos are based on the ClimateMachine.jl v0.2 release.

## VizCLIMA

[VizCLIMA](https://github.com/CliMA/VizCLIMA.jl/tree/ln/prep-for-merge) contains Julia-based scripts for analysis of output from the `ClimateMachine.jl`. It can be used as part of the end-to-end pipeline as shown above, or for stand alone analysis of output. Here are some examples:
- General
    - file load & info print ([.jl]](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/gcm-energy-spectra.jl#L37-L41))
    - file splitting
    - performance info table ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/bmark_sweep_targetted_vars_raw.jl#L184-L209))
- GCM
    - basic averaging and slicing([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/general-gcm-notebook-setup.jl), [.ipynb](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup.ipynb))
    - differences between experiments ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/general-gcm-notebook-setup-multi.jl), [.ipynb](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup-multi.ipynb))
    - 1d, 2d spectra ([.jl](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/gcm-energy-spectra.jl), [.ipynb](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/spectra_testdel.ipynb))
    - animations ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/hier_analysis_bcwave.jl#L97-L133))
    - functions atlas
- LES
    - vertical profiles ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/default_moist_les.jl))
    - 3d energy spectrum ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/taylorgreen_spectrum.jl))

To apply a Julia script on ClimateMachine.jl output, and convert it into a Jupyter Notebook using Literate, run:

```
VIZCLIMA_HOME=<location-of-your-VizCLIMA.jl>
VIZCLIMA_SCRIPT=<your-VizCLIMA.jl-script>
CLIMA_ANALYSIS=<location-of-your-NetCDF-file(s)>

julia --project=$VIZCLIMA_HOME -e 'using Pkg; Pkg.instantiate(); Pkg.API.precompile()'
VIZCLIMA_LITERATE=$VIZCLIMA_HOME'/src/utils/make_literate.jl'
julia --project=$VIZCLIMA_HOME $VIZCLIMA_LITERATE --input-file $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT --output-dir $CLIMA_ANALYSIS
```

### Gallery (use the scripts above)

## References:

- [setup jupyter notebook environment](https://github.com/CliMA/ClimateMachine.jl/wiki/Visualization)
- [end-to-end bash scripts](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts)
- [setup SLURM environment on Caltech's HPC and run ClimateMachine.jl](https://github.com/CliMA/ClimateMachine.jl/wiki/Caltech-Central-Cluster) (updated with each release): choose to run on CPU or GPU
