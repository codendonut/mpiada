with API;
with Datatype;

package Comm is

   type MPI_Comm is tagged record
      Handle : API.MPI_Comm_Handle;
   end record;

   function MPI_COMM_WORLD return MPI_Comm;

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

end Comm;
