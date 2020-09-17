---
title: "SLURM Bash Scripts"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: visualisation
---

These are examples of useful scripts for visualising output from ClimateMachine.jl

## VizCLIMA scripts for stand alone analysis of NetCDF files
- General
  - file load + info
  - file splitting
  - performance info table
- GCM
  - basic zonal mean / slice output (debugging )
  - 1d, 2d spectra
  - animations
- LES
  - vertical profiles
  - spectra

## Gallery (use the scripts above)

## End-to-end scripts
- [basic end-to-end](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts)
- [multi-experiment runs with performance info tracking](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts#step-by-step)

## End-to-end demos
- basic gcm
- plot the last timestep before crashing

References:
- [setup jupyter notebook environment](https://github.com/CliMA/ClimateMachine.jl/wiki/Visualization)
- [end-to-end bash scripts](https://github.com/CliMA/ClimateMachine.jl/wiki/Bash-Run-Scripts)
- [setup SLURM environment on Caltech's HPC and run ClimateMachine.jl](https://github.com/CliMA/ClimateMachine.jl/wiki/Caltech-Central-Cluster) (updated with each release): choose to run on CPU or GPU
