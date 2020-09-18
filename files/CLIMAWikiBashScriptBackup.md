Below we provide example SLURM shell scripts that tie together ``ClimateMachine.jl`` and ``VizCLIMA.jl`` for an end-to-end analysis pipeline.

# Run model and plot output from VisCLIMA.jl scripts
Demonstrates:
- environment setup for a GPU run on Caltech's HPC Cluster
- running ClimateMachine and its visualization with a VizCLIMA script
- saving restart files

```
#!/bin/bash

#SBATCH --nodes=1
#SBATCH --job-name=les_bomex
#SBARCH --qos=debug
#SBATCH --time=02:00:00
#SBATCH --gres=gpu:1
#SBATCH --tasks-per-node=1
#SBATCH --output=les_bomex.out

# Experiment variables
USER='USERNAME'
RUNNAME='les_bomex'
CLIMA_HOME=$HOME'/CLIMA'
VIZCLIMA_HOME=$HOME'/VizCLIMA'

# Model setup variables
MODE='AtmosLES'
EXPERIMENT='bomex.jl'
PPSCRIPT='default_moist_les.jl'

# Directory variables
CLIMA_RUNFILE=$CLIMA_HOME'/experiments/'$MODE'/'$EXPERIMENT
CLIMA_OUTPUT='/central/scratch/'$USER'/'$RUNNAME
CLIMA_RESTART=$CLIMA_OUTPUT'/restart'
CLIMA_NETCDF=$CLIMA_OUTPUT'/netcdf'
CLIMA_ANALYSIS=$CLIMA_OUTPUT'/analysis'
VIZCLIMA_LITERATE=$VIZCLIMA_HOME'/src/utils/make_literate.jl'
VIZCLIMA_SCRIPT=$VIZCLIMA_HOME'/src/scripts/'$PPSCRIPT

# Create directory structure
mkdir $CLIMA_OUTPUT
mkdir $CLIMA_RESTART
rm -rf $CLIMA_NETCDF # delete old data if present
mkdir $CLIMA_NETCDF
mkdir $CLIMA_ANALYSIS

# Make a copy of the original runfile for reference
cp $CLIMA_RUNFILE $CLIMA_RESTART

echo 'Running '$CLIMA_RUNFILE''
echo 'Storing output at '$CLIMA_OUTPUT
echo ''

# Kill the job if anything fails
set -euo pipefail

# Set up environment for ClimateMachine run
module purge
module load julia/1.3.1 hdf5/1.10.1 netcdf-c/4.6.1 cuda/10.0 openmpi/4.0.3_cuda-10.0 # CUDA-aware MPI

# Run climate model
julia --project=$CLIMA_HOME -e 'using Pkg; Pkg.instantiate(); Pkg.API.precompile()'
mpirun julia --project=$CLIMA_HOME $CLIMA_RUNFILE --diagnostics 10ssecs --monitor-courant-numbers 10ssecs --output-dir $CLIMA_NETCDF --checkpoint-at-end --checkpoint-dir $CLIMA_RESTART

# Set up environment for VizCLIMA
module unload julia/1.3.0
module load julia/1.4.0

# Post-process output data from ClimateMachine
julia --project=$VIZCLIMA_HOME -e 'using Pkg; Pkg.instantiate(); Pkg.API.precompile()'
julia --project=$VIZCLIMA_HOME $VIZCLIMA_LITERATE --input-file $VIZCLIMA_SCRIPT --output-dir $CLIMA_ANALYSIS
```

# Multi-run experiment that sweeps over select parameters and VizCLIMA.jl visualization
Demonstrates:
- performing multiple runs using ClimateMachine and comparing their output with a VizCLIMA script using one command line
- logging performance information

## Step-by step:
1. download ClimateMachine.jl and VizCLIMA.jl, e.g. into your ```$HOME``` directory
2. Save the following script with helper functions, e.g. as ```helper_mod.sh```,  in the ```ClimateMachine.jl``` directory:

```
#!/bin/bash

# these are helper functions for the pipeline_logging.sh program

function directory_structure {
  # Directory variables
  CLIMA_RESTART=$1'/restart'
  CLIMA_NETCDF=$1'/netcdf'
  CLIMA_LOG=$1'/log'
  CLIMA_ANALYSIS=$1'/analysis'

  # Create directory structure
  rm -rf $1 # delete old output if present
  mkdir $1
  mkdir $CLIMA_RESTART
  mkdir $CLIMA_NETCDF
  mkdir $CLIMA_ANALYSIS
  mkdir $CLIMA_LOG

  PERF_LOGFILE=$CLIMA_LOG'/experiments_performance_log'
  printf "%-70s %-20s %-15s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-150s \n" "driver" "sim_date" "wall_time" "sim_days" "res_h" "res_v" "dom_height" "CFL" "FT" "GPU" "Mem" "solver_details">> $PERF_LOGFILE
}

function write_into_runfile_from_list {

  line=$1
  runname=$2
  exp_folder=$(dirname "$3")
  default_exp_runfile=$(basename "$3")

	# Get all parameters
	pars=(${line// / });

	# Create name for this particular instance of this experiment
	inst_name=$runname;
	for ((i=0; i<${#pars[@]}; i++))
	do
		inst_name=$inst_name'_'${pars[$i]};
	done
  inst_name_clean="$(echo $inst_name | sed "s/[():]//g")" # remove special chars

	# Save namelist parameter names and values in separate arrays
	for ((i=0; i<${#pars[@]}; i+=2))
        do
		par_n[$(( $i / 2 ))]=${pars[$i]};
		par_v[$(( $i / 2 ))]=${pars[$(( $i + 1 ))]};
	done

	# Create a copy of the default run file and change to the specified parameters
  new_exp_runfile=${default_exp_runfile%.jl}"_"$inst_name_clean".jl";
  rm -f $exp_folder/$new_exp_runfile;

	# Replace the standard parameters in the run file copy by the modified parameters from $line
  cp $exp_folder/$default_exp_runfile $exp_folder/$new_exp_runfile;
  for ((i=0; i<${#par_n[@]}; i++))
	do
		sed "s/${par_n[$i]} =.*/${par_n[$i]} = ${par_v[$i]}/" $exp_folder/$new_exp_runfile > $exp_folder/run_tmp;
    mv $exp_folder/run_tmp $exp_folder/$new_exp_runfile;
  done

	# Replace default name in standard run file with name of this instance of the experiment $line
	sed "s/exp_name =.*/exp_name = \"$inst_name_clean\"/" $exp_folder/$new_exp_runfile > $exp_folder/run_tmp;
	mv $exp_folder/run_tmp $exp_folder/$new_exp_runfile;

  new_exp_runfile_path=$exp_folder/$new_exp_runfile;

  #Export the new CLIMA_RUNFILE name
  eval $4=$new_exp_runfile_path
}

function extract_vals {
  # From a line in the runfile, extract the value between = and #
  local var=${1}
  local var_=${var%#*}
  local var__=${var_##*=}
  echo $var__ | sed "s/[():]//g"
}

function write_into_perf_log_file {
  # Gather desired performance metrics

  # Imported metrics
  t_date=$3 # date of sim
  t_diff=$4 # wall time
  mem=$5 # rss

  # Metrics extracted from CLIMA_RUNFILE
  sim_time="$(extract_vals "$(grep "n_days =" $CLIMA_RUNFILE)")"
  res_h="$(extract_vals "$(grep "n_horz =" $CLIMA_RUNFILE)[@]")"
  res_v="$(extract_vals "$(grep "n_vert =" $CLIMA_RUNFILE)[@]")"
  domain_height="$(extract_vals "$(grep "domain_height::FT =" $CLIMA_RUNFILE)")"
  FT="$(extract_vals "$(grep "FT =" $CLIMA_RUNFILE)")"
  CFL="$(extract_vals "$(grep "CFL =" $CLIMA_RUNFILE)")"

  solver_method="$(extract_vals "$(grep "solver_method =" $CLIMA_RUNFILE)")"
  implicit_solver="$(extract_vals "$(grep "implicit_solver =" $CLIMA_RUNFILE)")"
  implicit_model="$(extract_vals "$(grep "implicit_model =" $CLIMA_RUNFILE)")"
  splitting_type="$(extract_vals "$(grep "splitting_type =" $CLIMA_RUNFILE)")"
  ode_solver_type="$(extract_vals "$(grep "ode_solver_type =" $CLIMA_RUNFILE)")"
  solver_details=$ode_solver_type/$solver_method/$implicit_solver/$implicit_model/$splitting_type

  gpu="none"

  printf "%-72s %-20s %-15s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-150s \n" $(basename "$CLIMA_RUNFILE") $t_date $t_diff $sim_time $res_h $res_v $domain_height $CFL  $FT $gpu $mem $solver_details >> $1
}

function get_peak_rss {
  # evaluated rss every second (TODO: may need a continuous metric if rss variable)
  pid=$1 peak=0
  while true; do
    sleep 1
    sample="$(ps -o rss= $pid 2> /dev/null)" || break
    let peak='sample > peak ? sample : peak'
  done
  echo $peak
}

```

3. Setup your runs with different parameters. Parameters in the experiment run file (e.g. ```/experiments/AtmosGCM/heldsuarez.jl```) will be automatically changed before each model run. The names and values of these parameters need to be specified in a separate script, e.g. ```exp_parameters```,  in the ClimateMachine.jl directory. This is a list of ```par1 val1 par2 val2 ... ```, where each line represents one model run. Note that parameter names must include all characters before the ```=``` sign, and values all of the characters after the``` =``` sign, as is in the experiment run file.  For example this script will initiate two experiments that will mean changing the following values in the ```/experiments/AtmosGCM/heldsuarez.jl```:

```
ΔT_y FT(70) n_days 1
ΔT_y FT(80) n_days 2
```

4. Setup your pipeline bash runscript, e.g. as ```pipeline_logging.sh```, in the ClimateMachine.jl directory, and customize your run name, choose which experiment to use (e.g. ```heldsuarez.jl```) and which VizCLIMA script to use (e.g. ```dry_gcm_sensitivity.jl```)

```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --job-name=hs_sweep
#SBARCH --qos=debug
#SBATCH --time=4:00:00
#SBATCH --gres=gpu:1
#SBATCH --tasks-per-node=1
#SBATCH --output=slurmlog.out


set -euo pipefail # kill the job at the first error
set -x # echo script

module purge;
module load julia/1.4.2 hdf5/1.10.1 netcdf-c/4.6.1 cuda/10.0 openmpi/4.0.3_cuda-10.0

export JULIA_NUM_THREADS=${SLURM_CPUS_PER_TASK:=1}
export JULIA_MPI_BINARY=system
export JULIA_CUDA_USE_BINARYBUILDER=false

# Import helper functions for this script
source ./helper_mod.sh

# User environment setup
RUNNAME='your_run_name'

# Change if CLIMA and VizCLIMA not saved in $HOME
CLIMA_HOME=$HOME'/ClimateMachine.jl'
VIZCLIMA_HOME=$HOME'/VizCLIMA.jl'

# Specify output location
mkdir -p $CLIMA_HOME'/output/'
CLIMA_OUTPUT=$CLIMA_HOME'/output/'$RUNNAME

# Choose CLIMA experiment script and VizCLIMA script
EXPERIMENT=$CLIMA_HOME'/experiments/AtmosGCM/heldsuarez.jl'
VIZCLIMA_SCRIPT=$VIZCLIMA_HOME'/src/scripts/dry_gcm_sensitivity.jl'

# Define a parameter file for experiment
EXP_PARAM_FILE=$CLIMA_HOME'/exp_parameters'

# Prepare directories and import Julia packages
directory_structure $CLIMA_OUTPUT

julia --project=$CLIMA_HOME -e 'using Pkg; Pkg.instantiate()'

# Run each experiment listed in EXP_PARAM_FILE
while read -u3 -r line
do
  # Prepare runfile with user-selected parameters
  write_into_runfile_from_list "${line}" "$RUNNAME" "$EXPERIMENT" CLIMA_RUNFILE

  # Run climate model
  t_date=$(date +'%m-%d-%y-%T');
  t_start=$(date +%s);

  echo $t_start': Running '$CLIMA_RUNFILE', storing output at '$CLIMA_OUTPUT
  julia --project=$CLIMA_HOME -e 'using Pkg; Pkg.API.precompile()'
  mpirun julia --project=$CLIMA_HOME $CLIMA_RUNFILE --diagnostics 1000steps --monitor-courant-numbers 1000steps --output-dir $CLIMA_NETCDF --checkpoint-at-end --checkpoint-dir $CLIMA_RESTART &

  # Get peak memory usage
  #pid=$!
  #peak_rss="$(get_peak_rss "$pid")"; # slows down the simulation, so unused by default
  peak_rss="switched off"

  # Get wall time
  t_end=$(date +%s);
  t_diff=$((t_end-t_start))

  # Write performance log file
  write_into_perf_log_file $PERF_LOGFILE $CLIMA_RUNFILE $t_date $t_diff $peak_rss

  sleep 2 # needed by the mpi
  mv $CLIMA_RUNFILE $CLIMA_LOG

done 3< $EXP_PARAM_FILE;

# Move the slurm logfile defined in the header above
mv slurmlog.out $CLIMA_LOG

# This modifies the VIZCLIMA_SCRIPT for this experiment
VIZCLIMA_SCRIPT_BN=$(basename "$VIZCLIMA_SCRIPT")
if [ -d "$CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT_BN" ]; then rm $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT_BN; fi
cp $VIZCLIMA_SCRIPT $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT_BN;
sed "s~CLIMA_ANALYSIS =.*~CLIMA_ANALYSIS = \"$CLIMA_ANALYSIS\"~" $VIZCLIMA_SCRIPT > $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT_BN;
sed "s~CLIMA_NETCDF =.*~CLIMA_NETCDF = \"$CLIMA_NETCDF\"~" $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT_BN > $CLIMA_ANALYSIS"/temp_an";
sed "s~RUNNAME =.*~RUNNAME = \"$RUNNAME\"~" $CLIMA_ANALYSIS"/temp_an" > $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT_BN;
rm $CLIMA_ANALYSIS"/temp_an";

# Post-process output data from ClimateMachine using VizCLIMA
julia --project=$VIZCLIMA_HOME -e 'using Pkg; Pkg.instantiate(); Pkg.API.precompile()'
VIZCLIMA_LITERATE=$VIZCLIMA_HOME'/src/utils/make_literate.jl'
julia --project=$VIZCLIMA_HOME $VIZCLIMA_LITERATE --input-file $CLIMA_ANALYSIS/$VIZCLIMA_SCRIPT_BN --output-dir $CLIMA_ANALYSIS

mv ${VIZCLIMA_SCRIPT_BN%.jl}.ipynb $CLIMA_ANALYSIS


```

5. Ensure write permissions are set ```chmod 775 pipeline_logging.sh```

6. Get a GPU node ```srun --pty -t 02:00:00 -n 1 -N 1 --gres gpu:1 /bin/bash -l```

7. ```unset SLURM_STEP_ID``` (for Julia MPI)

8. Run the experiment sweep ```sbatch pipeline_logging.sh```

## Output

Running the ```pipeline_logging.sh``` script above will run the ClimateMachine and generate an ```output/your_run_name``` directory with the following subdirectories:
1. **```analysis```**: contains a copy of the VizCLIMA script (e.g., ```dry_gcm_sensitivity.jl```), its Jupyter Notebook and any saved plots
2. **```log```**: contains ```experiments_performance_log``` with info on experiment setup, time/memory usage, resolution, solver details and other tracked parameters for each run. These can be modified in the ```helper_mod.sh``` file. This directory also contains copies of  the experiment run files for each run (e.g. ```heldsuarez_your_run_name_ΔT_y_FT70_n_days_1.jl``` and ```heldsuarez_your_run_name_ΔT_y_FT80_n_days_2.jl```), and the ```slurmlog.out``` file dumping all log and error messages.
3. **```netcdf```**: contains output files, e.g. ```your_run_name_ΔT_y_FT70_n_days_1_AtmosGCMDefault_...nc``` and ```your_run_name_ΔT_y_FT80_n_days_2_AtmosGCMDefault_...nc``` ```
4. **```restart```**: contains ```.jld2``` files for restart
