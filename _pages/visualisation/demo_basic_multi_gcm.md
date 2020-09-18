---
title: "Basic GCM Output"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: visualisation
---

Using the `heldsuarez.jl` driver, this demo shows how to run multiple experiments and plot their differences using one bash script.

1. Download [ClimateMachine.jl](https://github.com/CliMA/ClimateMachine.jl) and [VizCLIMA](https://github.com/CliMA/VizCLIMA.jl). For this demo use [this](https://github.com/CliMA/VizCLIMA.jl/tree/ln/prep-for-merge) VizCLIMA branch.

2. Setup the pipeline bash script in the `ClimateMachine.jl` directory as shown [here](), and change the highlighted lines.

3. Setup the `exp_parameters` file. This is a list of `par1 val1 par2 val2 ...` , where each line represents one model run. Note that parameter names must include all characters before the `=` sign, and values all of the characters after the `=` sign, as is in the experiment run file. For example, this script will modify the ```/experiments/AtmosGCM/heldsuarez.jl``` file and initiate three experiments of ΔT_y=(30K,60K,90K), each running for 0.5 days:

```
ΔT_y FT(60) n_days::FT 0.5
ΔT_y FT(30) n_days::FT 0.5
ΔT_y FT(90) n_days::FT 0.5
```

4. Copy the `helper_mod.sh` which contains functions for the automated parameter swapping.

5. Run script using `sbatch pipeline_logging_basic_multi_gcmd.sh`

6. Your specified output folder should contain
- `.../netcdf/` containing the diagnostics output `.nc` file
- `.../restart/` containing all restart `.jld2` files from individual nodes, for each experiment
- `.../log/` with:
    - `model_log_err.out` logfile
    - the three drivers for each experiment
- `.../analysis` with:
    - `general-gcm-notebook-setup-multi.jl` copied from VizCLIMA ([click here for demo](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup-multi.jl))
    - `plot_zonal_mean_anom.pdf`
    - `general-gcm-notebook-setup-multi.ipynb` Juputer Notebook whih is automatically generated ([click here for demo](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/general-gcm-notebook-setup-multi.ipynb))

7. View your notebook on a local machine
- On both local and remote machines:
    - ensure JupyterLab is installed on both local and remote machines (check version of Julia and necessary packages for your notebook)
- Remote host:
    - `cd` into your output directory
    - ```jupyter notebook --no-browser --port=XXXX```
- Local host:
    - ```ssh -N -f -L YYYY:localhost:XXXX <remoteuser>@<remote-cluster-node>```
    - In your local browser type ```localhost:YYYY```
    - You may get a prompt to authenticate using a token (printed when launched the notebook on the remote host), then you're good to go!
