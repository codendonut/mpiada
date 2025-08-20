with API;
with System;
with System.Storage_Elements;
with Mpiada_Config;
use type Mpiada_Config.MPI_Vendor_Kind;

package MPI_Ada.Constants is

   package OpenMPI is
      ompi_mpi_comm_world : constant API.MPI_Struct
      with Import => True, Convention => C;

      ompi_mpi_char : constant API.MPI_Struct
      with Import => True, Convention => C;

      ompi_mpi_double : constant API.MPI_Struct
      with Import => True, Convention => C;

      ompi_any_source : constant Integer := -1;

   end OpenMPI;

   package MPICH is
      mpich_mpi_comm_world : constant API.MPI_Comm_Handle :=
        API.MPI_Comm_Handle
          (System.Storage_Elements.To_Address (16#44000000#));

      mpich_mpi_char : constant API.MPI_Datatype_Handle :=
        API.MPI_Datatype_Handle
          (System.Storage_Elements.To_Address (16#4c000101#));

      mpich_mpi_double : constant API.MPI_Datatype_Handle :=
         API.MPI_Datatype_Handle
           (System.Storage_Elements.To_Address (16#4c00080b#));

      mpich_any_source : constant Integer := -2;
   end MPICH;

   MPI_ANY_TAG : constant Integer := -1;

   MPI_ANY_SOURCE : constant Integer :=
     (case Mpiada_Config.MPI_Vendor is
        when Mpiada_Config.openmpi =>
          OpenMPI.ompi_any_source,
        when Mpiada_Config.mpich => MPICH.mpich_any_source);

   MPI_COMM_WORLD : constant API.MPI_Comm_Handle :=
     (case Mpiada_Config.MPI_Vendor is
        when Mpiada_Config.openmpi =>
          API.MPI_Comm_Handle (OpenMPI.ompi_mpi_comm_world'Address),
        when Mpiada_Config.mpich => MPICH.mpich_mpi_comm_world);

   MPI_CHAR : constant API.MPI_Datatype_Handle :=
     (case Mpiada_Config.MPI_Vendor is
        when Mpiada_Config.openmpi =>
          API.MPI_Datatype_Handle (OpenMPI.ompi_mpi_char'Address),
        when Mpiada_Config.mpich => MPICH.mpich_mpi_char);

   MPI_DOUBLE : constant API.MPI_Datatype_Handle :=
     (case Mpiada_Config.MPI_Vendor is
        when Mpiada_Config.openmpi =>
          API.MPI_Datatype_Handle (OpenMPI.ompi_mpi_double'Address),
        when Mpiada_Config.mpich => MPICH.mpich_mpi_double);

end MPI_Ada.Constants;
