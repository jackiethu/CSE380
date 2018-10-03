#!/bin/bash
#
# Simple SLURM script for submitting multiple serial
# jobs (e.g. parametric studies) using a script wrapper
# to launch the jobs.
#
# To use, build the launcher executable and your
# serial application(s) and place them in your WORKDIR
# directory.  Then, edit the CONTROL_FILE to specify 
# each executable per process.
#-------------------------------------------------------
#-------------------------------------------------------
# 
#         <------ Setup Parameters ------>
#
#SBATCH -J Parametric 
#SBATCH -N 1
#SBATCH -n 48
#SBATCH -p skx-dev
#SBATCH -o Parametric.o%j
#SBATCH -t 00:10:00
#          <------ Account String ----->
# <--- (Use this ONLY if you have MULTIPLE accounts) --->
##SBATCH -A
#------------------------------------------------------

# set up enviroment
module load launcher

export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_SCHED=interleaved
export LAUNCHER_JOB_FILE=launcher_cmds.txt

# run parametric job launcher
$LAUNCHER_DIR/paramrun

# aggregate data
cat out.o* > out.dat
echo "# iter num_samples num_i pi relative_err time_accum" > iter.log
awk ' {   
    N_samples += $1
    N_i += $2
    time_accum += $6
}
END {
    pi_estimate = 4 * N_i / N_samples
    PI = 3.14159265358
    err = pi_estimate - PI
    e_rel = err > 0 ? err/PI : -err/PI
    printf("1 %d %d %f %g %g\n", N_samples, N_i, pi_estimate, e_rel, time_accum) >> "iter.log"
}     
' out.dat

# check relative error
iStop=$( awk 'END {if ($5 < 5e-6) print 0; else print 1}' iter.log )
while [ $iStop != 0 ]; do # if e_rel is too large, iterate
    # run parametric job launcher to compute additional 960,000,000 samples
    $LAUNCHER_DIR/paramrun
    # aggregate data
    cat out.o* > out.dat
    tac iter.log | head -1 > last_result
    awk ' 
    FNR == NR {
        N_samples = $2
        N_i = $3
        time_accum = $6
        next
    }
    {   
        N_samples += $1
        N_i += $2
        time_accum += $6
    }
    END {
        pi_estimate = 4 * N_i / N_samples
        PI = 3.14159265358
        err = pi_estimate - PI
        e_rel = err > 0 ? err/PI : -err/PI
        printf("1 %d %d %f %g %g\n", N_samples, N_i, pi_estimate, e_rel, time_accum) >> "iter.log"
    }     
    ' last_result out.dat

    iStop=$( awk 'END {if ($5 < 5e-6) print 0; else print 1}' iter.log )
done
