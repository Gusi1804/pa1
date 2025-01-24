#include <stdio.h>
#include <ctime>
#include <cstring>
#include <sstream>
#include <iomanip>
#include <iostream>
#include <mpi.h>
#include <cmath>

double pi_calc(long int n) {
    
    // Write your code below
    ////////////////////////////////////////

    int size, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &size);    
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // make sure that the random number generator is seeded differently for each processor
    srand(time(NULL) + rank);

    int assigned_points = n / size;
    if (rank == 0) {
        assigned_points += n % size; // assign the remainder when n doesn't divide evenly into p to processor 0
    }

    int i = 0;
    int inside = 0;

    while (i < assigned_points) {
        double x = rand() / RAND_MAX;
        double y = rand() / RAND_MAX;

        double length = std::sqrt(x*x + y*y);
        if (length <= 1.0) {
            inside++;
        }

        i++;
    }

    double global_sum;
    MPI_Reduce(&inside, &global_sum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        double result = 4.0 * global_sum / n;
        return result;
    }

    ////////////////////////////////////////
    return 0.0;
}
