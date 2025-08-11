![example workflow](https://github.com/codendonut/mpiada/actions/workflows/ada.yml/badge.svg)

# MPI_Ada

A personal research project for OpenMPI and MPICH bindings written in pure Ada.

## TODO

* Add more data types and their handles
* More functions
* More data types for send and recv (currently only char is supported)

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

## Using it

```ada
with Ada.Text_IO;
with MPI_Ada;
with Comm;
with Datatype;
with API;

procedure Example is
   package io renames Ada.Text_IO;

   world_comm : Comm.MPI_Comm;
   local_rank : Natural := 0;
   local_size : Natural := 0;
   init_str : constant String := "Hello World";
   result_str : String (1 .. init_str'Length) := "ZZZZZ ZZZZZ";
   result_status : API.MPI_Status;

begin

   MPI_Ada.Init ("example");
   world_comm := Comm.MPI_COMM_WORLD;

   local_rank := world_comm.Rank;
   if local_rank = 0 then
       io.Put_Line ("Rank is" & local_rank'Image);
   end if;

   local_size := world_comm.Size;
   if local_rank = 0 then
      io.Put_Line ("Size is" & local_size'Image);
   end if;

   world_comm.Barrier;

   if local_size > 1 then
      if local_rank = 0 then
         world_comm.Send
           (dest_rank => 1,
            tag       => 99,
            count     => init_str'Length,
            data_type => Datatype.MPI_CHAR,
            msg       => init_str);
      elsif local_rank = 1 then
         result_str :=
           world_comm.Recv
             (source_rank => 0,
              tag         => 99,
              count       => init_str'Length,
              data_type   => Datatype.MPI_CHAR,
              status      => result_status);
         io.Put_Line ("Received " & result_str);
      end if;
   end if;

   MPI_Ada.Finalize;

end Example;
```

## Additional Notes

There is a bug in MPICH in Ubuntu-24 that requires it to be launched
via mpirun.openmpi instead of the one packaged with mpich.
