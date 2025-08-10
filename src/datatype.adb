with Mpiada_Config;
use type Mpiada_Config.MPI_Vendor_Kind;

package body Datatype is
   function MPI_CHAR return MPI_Datatype is
      pragma Warnings (Off, "condition is always True");
      pragma Warnings (Off, "condition is always False");
   begin
      if Mpiada_Config.MPI_Vendor = Mpiada_Config.openmpi then
         declare
            MPI_CHAR_api : constant API.MPI_Datatype_Handle
            with
              Import => True,
              Convention => C,
              External_Name => "ompi_mpi_char";
         begin
            return (Handle => MPI_CHAR_api);
         end;

      elsif Mpiada_Config.MPI_Vendor = Mpiada_Config.mpich then
         return (Handle => API.MPI_Datatype_Handle (16#4c000101#));
      end if;

      raise Constraint_Error;
   end MPI_CHAR;

end Datatype;
