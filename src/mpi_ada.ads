with System;
with Interfaces.C;
with Constants;

package MPI_Ada is
   type MPI_Comm is tagged limited private;

   type MPI_Status is record
      Source : Integer;
      Tag    : Integer;
      Error  : Integer;
   end record;

   function "=" (left : MPI_Comm; right : MPI_Comm) return Boolean;

   function Init return MPI_Comm;
   procedure Finalize;

   function Size (comm : MPI_Comm'Class) return Natural;
   function Rank (comm : MPI_Comm'Class) return Natural;
   procedure Barrier (comm : MPI_Comm'Class);

   procedure Send
     (comm      : MPI_Comm'Class;
      dest_rank : Natural;
      tag       : Integer := Constants.MPI_ANY_TAG;
      msg       : String);

   function Recv
     (comm        : MPI_Comm'Class;
      source_rank : Integer := Constants.MPI_ANY_SOURCE;
      tag         : Integer := Constants.MPI_ANY_TAG;
      count       : Positive;
      status      : out MPI_Status) return String;

private
   type MPI_Comm_Handle is new System.Address;
   type C_Int_Ptr is new System.Address;
   type Argv_Ptr is new System.Address;
   type Message_Ptr is new System.Address;
   type MPI_Status_Handle is new System.Address;

   type MPI_Comm is tagged limited record
      Handle : MPI_Comm_Handle;
   end record;

   type MPI_Internal_Arr is
     array (Interfaces.C.int range 0 .. 4) of Interfaces.C.int;

   type MPI_Status_C is tagged record
      MPI_SOURCE   : Interfaces.C.int;
      MPI_TAG      : Interfaces.C.int;
      MPI_ERROR    : Interfaces.C.int;
      MPI_internal : MPI_Internal_Arr;
   end record
   with Convention => C;

   function MPI_Init (argc : C_Int_Ptr; argv : Argv_Ptr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Init";

   function MPI_Comm_f2c
     (comm_handle_in : Interfaces.C.int) return MPI_Comm_Handle
   with Import => True, Convention => C, External_Name => "MPI_Comm_f2c";

   function MPI_Comm_size
     (comm_addr_in : MPI_Comm_Handle; comm_size_out : C_Int_Ptr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_size";

   function MPI_Comm_rank
     (comm_addr_in : MPI_Comm_Handle; comm_rank_out : C_Int_Ptr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Comm_rank";

   function MPI_Barrier (comm_addr_in : MPI_Comm_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Barrier";

   function MPI_Finalize return Integer
   with Import => True, Convention => C, External_Name => "MPI_Finalize";

   function MPI_Send
     (buf         : Message_Ptr;
      count       : Interfaces.C.int;
      data_type   : Interfaces.C.int;
      dest_rank   : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : MPI_Comm_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Send";

   function MPI_Recv
     (buf_out     : Message_Ptr;
      count       : Interfaces.C.int;
      data_type   : Interfaces.C.int;
      source_rank : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : MPI_Comm_Handle;
      status_out  : MPI_Status_Handle) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Recv";

end MPI_Ada;
