#!/usr/bin/env bash
# Set walltime limit
#BSUB -W 05:59
#
# Set output file
#BSUB -o sensitivity.%J.log
#
# Specify node group
#BSUB -m "ls-gpu lt-gpu lp-gpu lg-gpu"
#BSUB -q gpuqueue
#
# nodes: number of nodes and GPU request
#BSUB -n 20
#BSUB -gpu "num=1:j_exclusive=yes:mode=shared" -R "rusage[mem=10] span[ptile=1]"
##BSUB -R "{rusage[mem=12,ngpus_physical=2] span[ptile=2]} || {rusage[mem=12,ngpus_physical=3] span[ptile=3]} || {rusage[mem=12,ngpus_physical=4] span[ptile=4]} || {rusage[mem=12,ngpus_physical=1] span[ptile=1]}"
#
# job name (default = name of script file)
#BSUB -J "sensitivity-lilac"

source activate yank 
build_mpirun_configfile --hostfilepath hostfile.${LSB_JOBNAME} --configfilepath configfile.${LSB_JOBNAME} "python run_yank.py --yaml=${LSB_JOBNAME}.yaml"
mpiexec.hydra -f hostfile.${LSB_JOBNAME} -configfile configfile.${LSB_JOBNAME}
