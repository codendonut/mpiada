with Mpiada_Config;
use type Mpiada_Config.MPI_Vendor_Kind;
with System;
with System.Storage_Elements;

package body Datatype is
   function MPI_CHAR return MPI_Datatype is
      pragma Warnings (Off, "condition is always True");
      pragma Warnings (Off, "condition is always False");
   begin
      if Mpiada_Config.MPI_Vendor = Mpiada_Config.openmpi then
         declare
            ompi_mpi_char : constant API.MPI_Struct
            with Import => True, Convention => C;
         begin
            return (Handle => API.MPI_Datatype_Handle (ompi_mpi_char'Address));
         end;

      elsif Mpiada_Config.MPI_Vendor = Mpiada_Config.mpich then
         return
           (Handle =>
              API.MPI_Datatype_Handle
                (System.Storage_Elements.To_Address (16#4c000101#)));
      end if;

      raise Constraint_Error;
   end MPI_CHAR;

end Datatype;
