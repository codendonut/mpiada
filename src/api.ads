with System;
with Interfaces.C;

package API is
   type MPI_Status is record
      Source : Integer;
      Tag    : Integer;
      Error  : Integer;
   end record;

   type OMP_Handle is null record;
   type Handle is new System.Address;
   type MPI_Comm_Handle is new Handle;
   type MPI_Datatype_Handle is new Handle;

   type MPI_Addr is new System.Address;
   type MPI_Status_Addr is new MPI_Addr;
   type C_Int_Addr is new MPI_Addr;
   type Argv_Addr is new MPI_Addr;

   type Message_Addr is new MPI_Addr;

   type MPI_Internal_Arr is
     array (Interfaces.C.int range 0 .. 4) of Interfaces.C.int;

   type MPI_Status_C is tagged record
      MPI_SOURCE   : Interfaces.C.int;
      MPI_TAG      : Interfaces.C.int;
      MPI_ERROR    : Interfaces.C.int;
      MPI_internal : MPI_Internal_Arr;
   end record
   with Convention => C;

   function MPI_Init (argc : C_Int_Addr; argv : Argv_Addr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Init";

   function MPI_Comm_size
     (comm_addr_in : MPI_Comm_Handle; comm_size_out : C_Int_Addr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_size";

   function MPI_Comm_rank
     (comm_addr_in : MPI_Comm_Handle; comm_rank_out : C_Int_Addr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_rank";

   function MPI_Barrier (comm_addr_in : MPI_Comm_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Barrier";

   function MPI_Finalize return Integer
   with Import => True, Convention => C, External_Name => "MPI_Finalize";

   function MPI_Send
     (buf         : Message_Addr;
      count       : Interfaces.C.int;
      data_type   : MPI_Datatype_Handle;
      dest_rank   : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : MPI_Comm_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Send";

   function MPI_Recv
     (buf_out     : Message_Addr;
      count       : Interfaces.C.int;
      data_type   : MPI_Datatype_Handle;
      source_rank : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : MPI_Comm_Handle;
      status_out  : MPI_Status_Addr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Recv";

end API;
