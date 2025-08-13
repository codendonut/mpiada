generic
   type Element is private;
   type Index is range <>;
   type T is array (Index range <>) of Element;
package MPI_Ada.Generic_Ops is
   function MPI_Send
     (buf         : T;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      dest_rank   : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : API.MPI_Comm_Handle) return Integer;

   function Send
     (comm_handle : API.MPI_Comm_Handle;
      buf         : T;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      dest_rank   : Interfaces.C.int;
      message_tag : Interfaces.C.int) return Integer;

   function MPI_Recv
     (buf_out     : out T;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      source_rank : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      comm_handle : API.MPI_Comm_Handle;
      status_out  : out MPI_Status) return Integer;

   function Recv
     (comm_handle : API.MPI_Comm_Handle;
      buf_out     : out T;
      count       : Interfaces.C.int;
      data_type   : API.MPI_Datatype_Handle;
      source_rank : Interfaces.C.int;
      message_tag : Interfaces.C.int;
      status_out  : out MPI_Status) return Integer;

end MPI_Ada.Generic_Ops;
