# FluentClusterJobs
Slurm based scheduling of Fluent simulation for FTSI and Fan


## Fluent non-GUI command-line/batch mode
Launch Fluent with a journal file that reads the case/data, runs iterations or timesteps, writes results, and exits.

### core command
    fluent 3ddp -g -t${SLURM_NTASKS} -i run.jou
    
    Command explanation
        3ddp  = 3D, double precision
        -g    = no GUI/graphics
        -tN   = use N parallel processes
        -i    = read Fluent journal file

### Basic slurm job

    #!/bin/bash
    #SBATCH --job-name=fluent_sbli
    #SBATCH --partition=compute
    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=32
    #SBATCH --time=24:00:00
    #SBATCH --output=fluent_%j.out
    #SBATCH --error=fluent_%j.err

    module purge
    module load ansys/2025R1   # adjust to your cluster

    cd $SLURM_SUBMIT_DIR

    export NPROCS=$SLURM_NTASKS

    fluent 3ddp -g -t${NPROCS} -mpi=intel -i run.jou

Note: Some clusters use -mpi=ibmmpi, -mpi=intel, -mpi=openmpi, or a site-specific wrapper.

## Practical workflow

1. Build and verify the setup once using GUI locally or interactively.
2. Save sbli_ready.cas.h5 or sbli_ready.cas/dat.
3. Use a journal only for:
    read case/data,
    apply any run-specific changes,
    initialize only if needed,
    run,
    autosave,
    write final files,
    exit.
4. Submit with sbatch fluent_job.sh.
5. Monitor with:
    squeue -u $USER
    tail -f fluent_<jobid>.out
    tail -f fluent_run.trn