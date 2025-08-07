with Ada.Command_Line;

package body MPI_Ada is
   package cmd renames Ada.Command_Line;

   function Find_Longest_Length (argc : Natural) return Natural is
      longest_len : Natural := 0;
   begin
      for i in 1 .. argc loop
         if cmd.Argument (i)'Length > longest_len then
            longest_len := cmd.Argument (i)'Length;
         end if;
      end loop;

      return longest_len;
   end Find_Longest_Length;

   function "=" (left : MPI_Comm; right : MPI_Comm) return Boolean is
   begin
      return left.Handle = right.Handle;
   end "=";

   function Init return MPI_Comm is
      argc        : Natural := cmd.Argument_Count;
      longest_len : Natural := 12;
      res         : Integer := 0;
   begin
      if argc > 1 then
         longest_len := Find_Longest_Length (argc);
      end if;

      declare
         argv :
           array (Positive range 1 .. argc + 1) of String (1 .. longest_len);
      begin
         argv (1) := "mutantsolver";
         argc := argc + 1;

         for i in 2 .. argc loop
            argv (i) := cmd.Argument (i);
         end loop;

         pragma Assert (argv'Length = argc);

         res := MPI_Init (C_Int_Ptr (argc'Address), Argv_Ptr (argv'Address));
      end;

      if res /= 0 then
         raise Program_Error;
      end if;

      return
        (Handle => MPI_Comm_f2c (Interfaces.C.int (Constants.MPI_COMM_WORLD)));

   end Init;

   procedure Finalize is
      res : Integer := 0;
   begin
      res := MPI_Finalize;
      if res /= 0 then
         raise Program_Error;
      end if;
   end Finalize;

   function Size (comm : MPI_Comm'Class) return Natural is
      res : Integer := 0;
      s   : Interfaces.C.int;
      use Interfaces.C;
   begin
      res := MPI_Comm_size (comm.Handle, C_Int_Ptr (s'Address));
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
      res := MPI_Comm_rank (comm.Handle, C_Int_Ptr (r'Address));
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
      res := MPI_Barrier (comm.Handle);
      if res /= 0 then
         raise Program_Error;
      end if;
   end Barrier;

   --  TODO : Make this a generic typed then use a type discriminant to select
   --  the MPI type
   procedure Send
     (comm      : MPI_Comm'Class;
      dest_rank : Natural;
      tag       : Integer := Constants.MPI_ANY_TAG;
      msg       : String)
   is
      res : Integer := 0;
   begin
      res :=
        MPI_Send
          (buf         => Message_Ptr (msg'Address),
           count       => Interfaces.C.int (msg'Length + 1),
           data_type   => Interfaces.C.int (Constants.MPI_CHAR),
           dest_rank   => Interfaces.C.int (dest_rank),
           message_tag => Interfaces.C.int (tag),
           comm_handle => comm.Handle);
      if res /= 0 then
         raise Program_Error;
      end if;
   end Send;

   function Recv
     (comm        : MPI_Comm'Class;
      source_rank : Integer := Constants.MPI_ANY_SOURCE;
      tag         : Integer := Constants.MPI_ANY_TAG;
      count       : Positive;
      status      : out MPI_Status) return String
   is
      res      : Integer := 0;
      msg      : String (1 .. count);
      status_c : MPI_Status_C;
   begin
      res :=
        MPI_Recv
          (buf_out     => Message_Ptr (msg'Address),
           count       => Interfaces.C.int (msg'Length + 1),
           data_type   => Interfaces.C.int (Constants.MPI_CHAR),
           source_rank => Interfaces.C.int (source_rank),
           message_tag => Interfaces.C.int (tag),
           comm_handle => comm.Handle,
           status_out  => MPI_Status_Handle (status_c'Address));
      if res /= 0 then
         raise Program_Error;
      end if;

      status :=
        (Error  => Integer (status_c.MPI_ERROR),
         Source => Integer (status_c.MPI_SOURCE),
         Tag    => Integer (status_c.MPI_TAG));

      return msg;
   end Recv;

end MPI_Ada;
