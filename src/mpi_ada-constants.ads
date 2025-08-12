with API;
with Comm;
with System;
with System.Storage_Elements;
with Mpiada_Config;
use type Mpiada_Config.MPI_Vendor_Kind;

package MPI_Ada.Constants is

   ompi_mpi_comm_world : constant API.MPI_Struct
   with Import => True, Convention => C;

   mpich_mpi_comm_world : constant API.MPI_Comm_Handle :=
     API.MPI_Comm_Handle (System.Storage_Elements.To_Address (16#44000000#));

   MPI_COMM_WORLD : Comm.MPI_Comm := (
      case Mpiada_Config.MPI_Vendor is
         when Mpiada_Config.openmpi =>
            (Handle => API.MPI_Comm_Handle (ompi_mpi_comm_world'Address)),
         when Mpiada_Config.mpich =>
            (Handle => mpich_mpi_comm_world));

end MPI_Ada.Constants;
