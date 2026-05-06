#!/bin/bash
#SBATCH --job-name=sbli_fluent
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --time=48:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

module purge
module load ansys/2025R1

cd $SLURM_SUBMIT_DIR

mkdir -p logs autosave results

echo "Job ID: $SLURM_JOB_ID"
echo "Nodes:"
scontrol show hostnames $SLURM_JOB_NODELIST
echo "Total MPI ranks: $SLURM_NTASKS"

fluent 3ddp \
  -g \
  -t${SLURM_NTASKS} \
  -mpi=intel \
  -i run.jou