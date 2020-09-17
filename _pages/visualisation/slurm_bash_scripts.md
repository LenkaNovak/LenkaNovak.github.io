---
title: "SLURM Bash Scripts"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: visualisation
---

These are examples of useful scripts for visualising output from `ClimateMachine.jl`

## VizCLIMA
### Scripts (for stand alone analysis of NetCDF files)
- General
  - file load + info
  - file splitting
  - performance info table
- GCM
  - basic zonal mean / slice output (debugging )
  - 1d, 2d spectra
  - animations
  - functions atlas
- LES
  - vertical profiles
  - spectra

### Gallery (use the scripts above)

## End-to-end modelling
### Scripts
- [Run LES experiment and plot some output](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts)
- [Set up multi-experiment GCM runs with performance info tracking on GPU](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts#step-by-step)

### Demos
- [Basic GCM: run and plot](visualisation/demo_basic_gcm.md)
- plot the last timestep before crashing
- sensitivity experiments
NB: these demos are based on the ClimateMachine.jl v0.2 release.

## References:
- [setup jupyter notebook environment](https://github.com/CliMA/ClimateMachine.jl/wiki/Visualization)
- [end-to-end bash scripts](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts)
- [setup SLURM environment on Caltech's HPC and run ClimateMachine.jl](https://github.com/CliMA/ClimateMachine.jl/wiki/Caltech-Central-Cluster) (updated with each release): choose to run on CPU or GPU
