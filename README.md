![example workflow](https://github.com/codendonut/mpiada/actions/workflows/ada.yml/badge.svg)

# MPIADA

Experimental pure Ada wrapper for personal research.

## TODO

* Add more data types and their handles
* Finish send and recv
* Scatter and gather

## Building with it
Run
```bash
alr with --use=https://github.com/codendonut/mpiada
```
### MPICH

Modify your toml use
```toml
[configuration.values]
mpiada.MPI_Vendor = "mpich"
```

run the following:
```bash
export MPI_LINKER_FLAGS="$(pkgconf --libs mpich)"
alr clean && alr build
```

### OpenMPI

Modify your toml use
```toml
[configuration.values]
mpiada.MPI_Vendor = "openmpi"
```

run the following:
```bash
export MPI_LINKER_FLAGS="$(pkgconf --libs ompi-c)"
alr clean && alr build
```

## Additional Notes

There is a bug in MPICH in Ubuntu-24 that requires it to be launched
via mpirun.openmpi instead of the one packaged with mpich.
