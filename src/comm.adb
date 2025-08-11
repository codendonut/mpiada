with Interfaces.C;
with Mpiada_Config;
use type Mpiada_Config.MPI_Vendor_Kind;
with System;
with System.Storage_Elements;

package body Comm is

   function MPI_COMM_WORLD return MPI_Comm is
      pragma Warnings (Off, "condition is always True");
      pragma Warnings (Off, "condition is always False");
   begin
      if Mpiada_Config.MPI_Vendor = Mpiada_Config.openmpi then
         declare
            ompi_mpi_comm_world : constant API.MPI_Struct
            with Import => True, Convention => C;

         begin
            return
              (Handle => API.MPI_Comm_Handle (ompi_mpi_comm_world'Address));
         end;

      elsif Mpiada_Config.MPI_Vendor = Mpiada_Config.mpich then
         return
           (Handle =>
              API.MPI_Comm_Handle
                (System.Storage_Elements.To_Address (16#44000000#)));
      end if;

      raise Constraint_Error;
   end MPI_COMM_WORLD;

   function Size (comm : MPI_Comm'Class) return Natural is
      res : Integer := 0;
      s   : Interfaces.C.int;
      use Interfaces.C;
   begin
      res := API.MPI_Comm_size (comm.Handle, API.C_Int_Addr (s'Address));
      if res /= 0 then
         raise Program_Error;
      end if;
      if s < 0 then
         raise Program_Error;
      end if;

      return Natural (s);
   end Size;

   function Rank (comm : MPI_Comm'Class) return Natural is
      res : Integer := 0;
      r   : Interfaces.C.int;
      use Interfaces.C;
   begin
      res := API.MPI_Comm_rank (comm.Handle, API.C_Int_Addr (r'Address));
      if res /= 0 then
         raise Program_Error;
      end if;
      if r < 0 then
         raise Program_Error;
      end if;

      return Natural (r);
   end Rank;

   procedure Barrier (comm : MPI_Comm'Class) is
      res : Integer := 0;
   begin
      res := API.MPI_Barrier (comm.Handle);
      if res /= 0 then
         raise Program_Error;
      end if;
   end Barrier;

   --  TODO : Make this a generic typed then use a type discriminant to select
   --  the MPI type
   procedure Send
     (comm      : MPI_Comm'Class;
      dest_rank : Natural;
      tag       : Integer;
      count     : Positive;
      data_type : Datatype.MPI_Datatype;
      msg       : String)
   is
      res : Integer := 0;
   begin
      res :=
        API.MPI_Send
          (buf         => API.Message_Addr (msg'Address),
           count       => Interfaces.C.int (count),
           data_type   => data_type.Handle,
           dest_rank   => Interfaces.C.int (dest_rank),
           message_tag => Interfaces.C.int (tag),
           comm_handle => comm.Handle);
      if res /= 0 then
         raise Program_Error;
      end if;
   end Send;

   function Recv
     (comm        : MPI_Comm'Class;
      source_rank : Integer;
      tag         : Integer;
      count       : Positive;
      data_type   : Datatype.MPI_Datatype;
      status      : out API.MPI_Status) return String
   is
      res      : Integer := 0;
      msg      : String (1 .. count);
      status_c : API.MPI_Status_C;
   begin
      res :=
        API.MPI_Recv
          (buf_out     => API.Message_Addr (msg'Address),
           count       => Interfaces.C.int (msg'Length + 1),
           data_type   => data_type.Handle,
           source_rank => Interfaces.C.int (source_rank),
           message_tag => Interfaces.C.int (tag),
           comm_handle => comm.Handle,
           status_out  => API.MPI_Status_Addr (status_c'Address));
      if res /= 0 then
         raise Program_Error;
      end if;

      status :=
        (Error  => Integer (status_c.MPI_ERROR),
         Source => Integer (status_c.MPI_SOURCE),
         Tag    => Integer (status_c.MPI_TAG));

      return msg;
   end Recv;

end Comm;
