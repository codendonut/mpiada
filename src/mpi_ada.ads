with System;
with Interfaces.C;

package MPI_Ada is
   type MPI_Comm is tagged private;

   function Init return MPI_Comm;

   procedure Barrier (comm : MPI_Comm'Class);
   function Size (comm : MPI_Comm'Class) return Natural;
   function Rank (comm : MPI_Comm'Class) return Natural;

   procedure Finalize;

private
   subtype MPI_Comm_Handle is System.Address;
   subtype C_Int_Ptr is System.Address;

   type MPI_Comm is tagged record
      Handle : MPI_Comm_Handle;
   end record;

   function MPI_Comm_f2c
     (comm_handle_in : Interfaces.C.int) return MPI_Comm_Handle
   with Import => True, Convention => C, External_Name => "MPI_Comm_f2c";

   function MPI_Comm_f2c_i
     (comm_handle_in : Interfaces.C.int) return Interfaces.C.int
   with Import => True, Convention => C, External_Name => "MPI_Comm_f2c";

   function MPI_Comm_size
     (comm_addr_in : MPI_Comm_Handle; comm_size_out : C_Int_Ptr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_size";

   function MPI_Comm_rank
     (comm_addr_in : MPI_Comm_Handle; comm_rank_out : C_Int_Ptr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_rank";

   function MPI_Init
     (argc : C_Int_Ptr; argv : System.Address) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Init";

   function MPI_Barrier (comm_addr_in : MPI_Comm_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Barrier";

   function MPI_Finalize return Integer
   with Import => True, Convention => C, External_Name => "MPI_Finalize";

end MPI_Ada;
