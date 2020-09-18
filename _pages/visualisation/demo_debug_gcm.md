---
title: "Debugging for GCM"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: visualisation
---

This builds on the [Basic GCM pipeline page](https://lenkanovak.github.io/_pages/visualisation/demo_basic_gcm/), and shows how to:

- output last *model* timestep in CPU
- print the location of crash

This is an interim solution and the demo branch can be seen here [here](https://github.com/CliMA/ClimateMachine.jl/tree/ln/demo-debug). It uses the Held Suarez setup, using the GCMdriver (modularised driver which let you easily mix and match initial and boundary conditions, and sources).

How it works:
- The model is initially run with 128 nodes, crashes after 17 days
- The last diagnostic timestep is saved as 128 restart files
- restart files from all nodes are combined into one
- the script then reruns the  model from the restart file on one node, which allows the diagnostics to be applied coherently
- using a `try ... catch` statement, the last model timestep at crash is saved in the same format as the standard diagnostic output

Note that these files also had to be modified, as well as the pipeline script, to be able to save the last timestep
- `src/Diagnostics/atmos_gcm_default.jl`
- `src/Driver/Driver.jl`
- `assemble_checkpoints.jl` based on [this script](https://github.com/CliMA/ClimateMachine.jl/wiki/Assemble-checkpoints)
- (`helper.sh`, `exp_parameter` can be removed if also removed from the pipeline script)

1. If you know the function that crashed, add some print some variable info and crash point location, like [here](https://github.com/CliMA/ClimateMachine.jl/blob/ln/demo-debug/src/Atmos/Model/moisture.jl#L165-L171)

2. Run script on *CPU* using `sbatch pipeline_logging_gcmd_precrash.sh`

3. Your specified output folder should contain
    - `.../netcdf/` containing the diagnostics output `.nc` file and the `last_c
  rash_HeldSuarez ... .nc` file
    - `.../restart/` containing all restart `.jld2` files from individual nodes
    - `.../log/` containing `model_log_err.out` logfile

4. View Output
    - printed info on crash point can be found in the `model_log_err.out` logfile
    - for a quick visualisation of the crash location on the Caltech cluster, it is recommended to use `ncview <namefile>`
