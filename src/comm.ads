with API;
with Datatype;
with Interfaces.C;

package Comm is

   type MPI_Comm is tagged record
      Handle : API.MPI_Comm_Handle;
   end record;

   function Size (comm : MPI_Comm'Class) return Natural;
   function Rank (comm : MPI_Comm'Class) return Natural;
   procedure Barrier (comm : MPI_Comm'Class);

   procedure Send
     (comm      : MPI_Comm'Class;
      dest_rank : Natural;
      tag       : Integer;
      count     : Positive;
      data_type : Datatype.MPI_Datatype;
      msg       : String);

   function Recv
     (comm        : MPI_Comm'Class;
      source_rank : Integer;
      tag         : Integer;
      count       : Positive;
      data_type   : Datatype.MPI_Datatype;
      status      : out API.MPI_Status) return String;

private

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

end Comm;
