with API;
with Interfaces.C;

package Funcs is

   function MPI_Init
     (argc : API.C_Int_Addr; argv : API.Argv_Addr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Init";

   function MPI_Finalize return Integer
   with Import => True, Convention => C, External_Name => "MPI_Finalize";

   function MPI_Comm_size
     (comm_addr_in : API.MPI_Comm_Handle; comm_size_out : API.C_Int_Addr)
      return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_size";

   function MPI_Comm_rank
     (comm_addr_in : API.MPI_Comm_Handle; comm_rank_out : API.C_Int_Addr)
      return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_rank";

   function MPI_Barrier (comm_addr_in : API.MPI_Comm_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Barrier";

   function MPI_Send
     (buf         : API.Message_Addr;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      dest_rank   : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : API.MPI_Comm_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Send";

   function MPI_Recv
     (buf_out     : API.Message_Addr;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      source_rank : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : API.MPI_Comm_Handle;
      status_out  : API.MPI_Status_Addr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Recv";

end Funcs;
