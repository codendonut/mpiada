with API;
with System.Storage_Elements;
with Mpiada_Config;

package Datatype is
   use type Mpiada_Config.MPI_Vendor_Kind;
   type MPI_Datatype is tagged record
      Handle : API.MPI_Datatype_Handle;
   end record;

   ompi_mpi_char : constant API.MPI_Struct
   with Import => True, Convention => C;

   mpich_mpi_char : constant API.MPI_Datatype_Handle :=
     API.MPI_Datatype_Handle
       (System.Storage_Elements.To_Address (16#4c000101#));

   MPI_CHAR : MPI_Datatype := (
      case Mpiada_Config.MPI_Vendor is
         when Mpiada_Config.openmpi =>
            (Handle => API.MPI_Datatype_Handle (ompi_mpi_char'Address)),
         when Mpiada_Config.mpich =>
            (Handle => mpich_mpi_char));

end Datatype;
