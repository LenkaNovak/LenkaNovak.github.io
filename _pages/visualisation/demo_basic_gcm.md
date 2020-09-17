---
title: "Basic GCM Output"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: visualisation
---

Say I want to run the GCM in the Held Suarez setup, using the GCMdriver (modularised driver which let you easily mix and match initial and boundary conditions, and sources).

1. Download [ClimateMachine.jl](https://github.com/CliMA/ClimateMachine.jl) and [VizCLIMA](https://github.com/CliMA/VizCLIMA.jl). For this demo use [this](https://github.com/CliMA/VizCLIMA.jl/tree/ln/prep-for-merge) VizCLIMA branch.

2. Setup the pipeline bash script in the `ClimateMachine.jl` directory as shown [here](https://github.com/CliMA/ClimateMachine.jl/blob/1d90c69dd687850c22c79a555c780919987b2e7a/pipeline_logging_basic_gcmd.sh#L20-L29), and change the highlighted lines.

3. Your specified output folder should contain
    - `.../netcdf/` containing the diagnostics output `.nc` file
    - `.../restart/` containing all restart `.jld2` files from individual nodes
    - `.../log/` containing `model_log_err.out` logfile
    - `.../analysis` with:
        - `general-gcm-notebook-setup.jl` copied from VizCLIMA [click here for demo](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup.jl)
        - `zontal_mean.pdf`
        - `vertical_slice.pdf`
        - `general-gcm-notebook-setup.ipynb` Juputer Notebook automatically generated from `general-gcm-notebook-setup.jl` ([click here for demo](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup.ipynb))

4. View your notebook on a local machine
    - On both local and remote machines:
        - ensure JupyterLab is installed on both local and remote machines (check version of Julia and necessary packages for your notebook)
    - Remote host:
        - `cd` into your output directory
        - ```jupyter notebook --no-browser --port=XXXX```
    - Local host:
        - ```ssh -N -f -L YYYY:localhost:XXXX <remoteuser>@<remote-cluster-node>```
        - In your local browser type ```localhost:YYYY```
        - You may get a prompt to authenticate using a token (printed when launched the notebook on the remote host), then you're good to go!
