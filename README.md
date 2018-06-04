# gameoflife
## Conway's Game of Life in Fortran 95
This is a personal project to learn about netCDF in Fortran

It is divided in two files: 
- **main.f95** : program read initial state 10x10 from /data/gol00.csv, calls subroutine golmod, and writes netCDF file (and CSVs).
- **golmod.f95** : subroutine that implements the 4 rules of Conway's Game of Life and gives back the result for each time step.
- **_netcdf.mod_** : this header from netcdf-fortran is also required, copy it in the main folder or add path ```-I$PATH```

### Compilation
The compilation was tested with GNU Fortran (GCC) 6.3.1

1. Compile the subroutine golmod.f95: ```gfortran -c golmod.95```
2. Compile the main.f95 with your netcdf.mod: ```gfortran -o main main.95 golmod.o -lnetcdff```
3. Run the program: ```./main```
