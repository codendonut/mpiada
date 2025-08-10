![example workflow](https://github.com/codendonut/mpiada/actions/workflows/ada.yml/badge.svg)

# MPI_Ada

A personal research project for OpenMPI and MPICH bindings written in pure Ada.

## TODO

* Add more data types and their handles
* Finish send and recv
* Scatter and gather

## Getting it

```bash
alr with --use=https://github.com/codendonut/mpiada
```

## Choosing a driver

Modify your alire.toml

```toml
[configuration.values]
mpiada.MPI_Vendor = "openmpi"
```

or

```toml
[configuration.values]
mpiada.MPI_Vendor = "mpich"
```

## Building with it

Add the following to your GPR file (or something similar):

```ada
   package Linker is
      for Required_Switches use external_as_list ("MPI_LINKER_FLAGS", " ");
   end Linker;
```

### MPICH

run the following using the environment variable defined earlier:

```bash
export MPI_LINKER_FLAGS="$(pkgconf --libs mpich)"
alr clean && alr build
```

### OpenMPI

run the following using the environment variable defined earlier:

```bash
export MPI_LINKER_FLAGS="$(pkgconf --libs ompi-c)"
alr clean && alr build
```

## Additional Notes

There is a bug in MPICH in Ubuntu-24 that requires it to be launched
via mpirun.openmpi instead of the one packaged with mpich.
