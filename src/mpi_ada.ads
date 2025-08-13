with API;
with Funcs;
with Interfaces.C;

package MPI_Ada is
   type MPI_Internal_Arr is
     array (Interfaces.C.int range 0 .. 4) of Interfaces.C.int;

   type MPI_Status is record
      MPI_SOURCE   : Interfaces.C.int;
      MPI_TAG      : Interfaces.C.int;
      MPI_ERROR    : Interfaces.C.int;
      MPI_internal : MPI_Internal_Arr;
   end record
   with Convention => C;

   function MPI_Init (program_name : String) return Integer;
   function Init (program_name : String) return Integer renames MPI_Init;

   function MPI_Finalize return Integer renames Funcs.MPI_Finalize;
   function Finalize return Integer renames Funcs.MPI_Finalize;

   function MPI_Comm_size
     (comm : API.MPI_Comm_Handle; size : out Integer) return Integer;
   function Size
     (comm : API.MPI_Comm_Handle; size : out Integer) return Integer renames
      MPI_Comm_size;

   function MPI_Comm_rank
     (comm : API.MPI_Comm_Handle; rank : out Integer) return Integer;
   function Rank
     (comm : API.MPI_Comm_Handle; rank : out Integer) return Integer renames
     MPI_Comm_rank;

   function MPI_Barrier (comm_addr_in : API.MPI_Comm_Handle) return Integer
   renames Funcs.MPI_Barrier;

   function Barrier (comm_addr_in : API.MPI_Comm_Handle) return Integer
   renames Funcs.MPI_Barrier;

end MPI_Ada;
