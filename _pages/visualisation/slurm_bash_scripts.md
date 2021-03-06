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

[VizCLIMA](https://github.com/CliMA/VizCLIMA.jl/tree/ln/prep-for-merge) contains Julia-based scripts for analysis of output from the `ClimateMachine.jl`. It can be used as part of the end-to-end pipeline, as shown above, or for stand-alone analysis of `.nc` output. Here are some examples:
- General
    - file load & info print ([.jl](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/gcm-energy-spectra.jl#L37-L41))
    - file splitting ([.jl](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/extract_subsets_of_ncfiles.jl))
    - performance info table ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/bmark_sweep_targetted_vars_raw.jl#L184-L209))
- GCM
    - basic averaging and slicing([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/general-gcm-notebook-setup.jl), [.ipynb](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup.ipynb))
    - differences between experiments ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/general-gcm-notebook-setup-multi.jl), [.ipynb](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup-multi.ipynb))
    - 1D and 2D energy spectra ([.jl](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/gcm-energy-spectra.jl), [.ipynb](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/spectra_testdel.ipynb))
    - animation: LES simple ([.jl](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/les-simple-animation.jl), [.ipynb](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/les-simple-animation.ipynb))
    - animation: multi-run GCM comparisons ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/hier_analysis_bcwave.jl#L97-L133))

- LES
    - vertical profiles ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/default_moist_les.jl))
    - 3D energy spectrum ([.jl](https://github.com/CliMA/VizCLIMA.jl/blob/ln/prep-for-merge/src/scripts/taylorgreen_spectrum.jl))

To apply a Julia script on ClimateMachine.jl output, and convert it into a Jupyter Notebook using Literate, run:

```
VIZCLIMA_HOME=<location-of-your-VizCLIMA.jl>
VIZCLIMA_SCRIPT=<your-VizCLIMA.jl-script>
CLIMA_ANALYSIS=<location-of-your-NetCDF-file(s)>

julia --project=$VIZCLIMA_HOME -e 'using Pkg; Pkg.instantiate(); Pkg.API.precompile()'
VIZCLIMA_LITERATE=$VIZCLIMA_HOME'/src/utils/make_literate.jl'
julia --project=$VIZCLIMA_HOME $VIZCLIMA_LITERATE --input-file $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT --output-dir $CLIMA_ANALYSIS
```

### Tips
- when analysing large data files, Jupyter Notebooks can be very slow, so the computation is recommended to be done using Julia scripts and on a compute node (e.g. `hpc-89-24`). For optimising your code in Julia see, for example, [this](https://www.youtube.com/watch?time_continue=4856&v=M2i7sSRcSIw&feature=emb_logo) tutorial.
- use `ncview` for fast exploration of large GCM output when on Caltech Cluster

### Gallery (use the scripts above)

## References

- CliMA Wiki:
    - [end-to-end bash scripts](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts)
    - [Setup JupyterLab on Caltech Cluster](https://github.com/CliMA/ClimateMachine.jl/wiki/Visualization)
    - [setup SLURM environment on Caltech's Cluster and run ClimateMachine.jl](https://github.com/CliMA/ClimateMachine.jl/wiki/Caltech-Central-Cluster) (updated with each release): choose to run on CPU or GPU
- [initial GCM physics testing](https://lenkanovak.github.io/_pages/random/gcm_tests/)
