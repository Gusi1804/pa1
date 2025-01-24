#!/bin/bash

#SBATCH --job-name=graph
#SBATCH --output=graph.out
#SBATCH --error=graph.err
#SBATCH --nodes=1
#SBATCH --constraint=gold6226
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:05:00
#SBATCH --exclusive

# Maximum time allowed for the script (in seconds)
MAX_EXECUTION_TIME=180

# Run the tests within the time limit
timeout $MAX_EXECUTION_TIME bash -c '

lscpu
echo "-------------------------------------"

# Run the tests
module load openmpi

make clean
make

# Tests
echo "-------------------------------------"
echo "n = 1000000000"
echo "p=1"
output1=$(mpirun -np 1 ./pi -n 1000000000)
estimated_pi1=$(echo "$output1" | grep "Estimated Pi" | awk "{print \$3}")
time1=$(echo "$output1" | grep "Time" | awk "{print \$2}")
echo "Pi: ($estimated_pi1)"
echo "Time ($time1 seconds)"

echo "p=6"
output2=$(mpirun -np 6 ./pi -n 1000000000)
estimated_pi2=$(echo "$output2" | grep "Estimated Pi" | awk "{print \$3}")
time2=$(echo "$output2" | grep "Time" | awk "{print \$2}")
echo "Pi: ($estimated_pi2)"
echo "Time ($time2 seconds)"

echo "p=12"
output3=$(mpirun -np 12 ./pi -n 1000000000)
estimated_pi3=$(echo "$output3" | grep "Estimated Pi" | awk "{print \$3}")
time3=$(echo "$output3" | grep "Time" | awk "{print \$2}")
echo "Pi: ($estimated_pi3)"
echo "Time ($time3 seconds)"

echo "p=24"
output4=$(mpirun -np 24 ./pi -n 1000000000)
estimated_pi4=$(echo "$output4" | grep "Estimated Pi" | awk "{print \$3}")
time4=$(echo "$output4" | grep "Time" | awk "{print \$2}")
echo "Pi: ($estimated_pi4)"
echo "Time ($time4 seconds)"
echo "-------------------------------------"
'

if [[ $? -eq 124 ]]; then
    echo "Error: Script execution exceeded $MAX_EXECUTION_TIME seconds."
    exit 1
fi