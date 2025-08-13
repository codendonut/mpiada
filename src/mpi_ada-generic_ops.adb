package body MPI_Ada.Generic_Ops is

   function MPI_Send
     (buf         : T;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      dest_rank   : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : API.MPI_Comm_Handle) return Integer is
   begin
      return
        Funcs.MPI_Send
          (API.Message_Addr (buf'Address),
           count,
           data_type,
           dest_rank,
           message_tag,
           comm_handle);
   end MPI_Send;

   function MPI_Recv
     (buf_out     : out T;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      source_rank : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : API.MPI_Comm_Handle;
      status_out  : out MPI_Status) return Integer is
   begin
      return
        Funcs.MPI_Recv
          (API.Message_Addr (buf_out'Address),
           count,
           data_type,
           source_rank,
           message_tag,
           comm_handle,
           API.MPI_Status_Addr (status_out'Address));
   end MPI_Recv;

end MPI_Ada.Generic_Ops;
