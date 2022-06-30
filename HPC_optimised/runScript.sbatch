{\rtf1\ansi\ansicpg1252\cocoartf2636
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red224\green51\blue34;\red212\green34\blue255;\red0\green0\blue0;
\red209\green113\blue37;\red178\green48\blue128;}
{\*\expandedcolortbl;;\cssrgb\c91312\c29124\c17211;\cssrgb\c87270\c29648\c100000;\csgray\c0;
\cssrgb\c85992\c52028\c18736;\cssrgb\c75801\c28659\c57530;}
\paperw11900\paperh16840\margl1440\margr1440\vieww15000\viewh8400\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs22 \cf2 \CocoaLigature0 #!/bin/\cf3 bash\cf2                                                                    \cf4 \
\cf2                                                                                 \cf4 \
\cf2 #SBATCH --nodes=1                                                                                                                                    \cf4 \
\cf2 #SBATCH --ntasks-per-node=16                                                                                                                                \cf4 \
\cf2 #SBATCH --mem-per-cpu=3882                                                                                                                                 \cf4 \
\cf2 #SBATCH --time=96:00:00   \
\
\cf4 module load parallel/20170622 MATLAB\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0
\cf5 MY_PARALLEL_OPTS\cf4 =\cf6 "-N 1 --delay .5 -j $SLURM_NTASKS --joblog parallel-$\{SLURM_JOBID\}.log"\cf4 \
\cf5 MY_SRUN_OPTS\cf4 =\cf6 "-N 1 -n 1"\cf4 \
\cf5 MY_EXEC\cf4 =\cf6 "matlab -singleCompThread -nosplash -nodisplay -r 'runFunct(\{1\},1); exit;' </dev/null"\cf4 \
\
parallel $\cf5 MY_PARALLEL_OPTS\cf4  srun $\cf5 MY_SRUN_OPTS\cf4  $\cf5 MY_EXEC\cf4  ::: \{1..16\}\
\
}