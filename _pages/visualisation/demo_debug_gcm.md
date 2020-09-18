---
title: "Debugging for GCM"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: visualisation
---

This builds on the [Basic GCM pipeline page](https://lenkanovak.github.io/_pages/visualisation/demo_basic_gcm/), and shows how to:

- output last *model* timestep in CPU
- print the location of crash (e.g., [here](https://github.com/CliMA/ClimateMachine.jl/blob/ln/demo-debug/src/Atmos/Model/moisture.jl#L165-L171))

This is an interim solution and the working branch. It uses the Held Suarez setup, using the GCMdriver (modularised driver which let you easily mix and match initial and boundary conditions, and sources).

How it works:
- The model is initially run with 128 nodes, crashes after 17 days
- The last diagnostic timestep is saved as 128 restart files
- restart files from all nodes are combined into one
- the script then reruns the  model from the restart file on one node, which allows the diagnostics to be applied coherently
- using a `try ... catch` statement, the last model timestep at crash is saved in the same format as the standard diagnostic output
- for quick visualisation of the crash location on the Caltech cluster, it is recommended to use `ncview <namefile>`

Note that these files also had to be modified, as well as the pipeline script, to be able to save the last timestep
- `src/Diagnostics/atmos_gcm_default.jl`
- `src/Driver/Driver.jl`
- `assemble_checkpoints.jl` based on [this script]()
- (`helper.sh`, `exp_parameter` can be removed if also removed from the pipeline script)

1. Run script on *CPU* using `sbatch pipeline_logging_gcmd_precrash.sh`

2. Your specified output folder should contain
    - `.../netcdf/` containing the diagnostics output `.nc` file and the `last_c
  rash_HeldSuarez ... .nc` file
    - `.../restart/` containing all restart `.jld2` files from individual nodes
    - `.../log/` containing `model_log_err.out` logfile

3. View Output
    - for quick visualisation of the crash location on the Caltech cluster, it is recommended to use `ncview <namefile>`
