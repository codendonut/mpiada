with Ada.Command_Line;

package body Common is
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

   procedure Init (program_name : String) is
      argc        : Natural := cmd.Argument_Count;
      longest_len : Natural := program_name'Length;
      res         : Integer := 0;
   begin
      if argc > 1 then
         longest_len := Find_Longest_Length (argc);
      end if;

      declare
         argv :
           array (Positive range 1 .. argc + 1) of String (1 .. longest_len);
      begin
         argv (1) := program_name;
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

   end Init;

   procedure Finalize is
      res : Integer := 0;
   begin
      res := MPI_Finalize;
      if res /= 0 then
         raise Program_Error;
      end if;
   end Finalize;

   function Size (comm : MPI_Comm_Base'Class) return Natural is
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

   function Rank (comm : MPI_Comm_Base'Class) return Natural is
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

   procedure Barrier (comm : MPI_Comm_Base'Class) is
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
     (comm      : MPI_Comm_Base'Class;
      dest_rank : Natural;
      tag       : Integer;
      data_type : Integer;
      msg       : String)
   is
      res : Integer := 0;
   begin
      res :=
        MPI_Send
          (buf         => Message_Ptr (msg'Address),
           count       => Interfaces.C.int (msg'Length + 1),
           data_type   => Interfaces.C.int (data_type),
           dest_rank   => Interfaces.C.int (dest_rank),
           message_tag => Interfaces.C.int (tag),
           comm_handle => comm.Handle);
      if res /= 0 then
         raise Program_Error;
      end if;
   end Send;

   function Recv
     (comm        : MPI_Comm_Base'Class;
      source_rank : Integer;
      tag         : Integer;
      count       : Positive;
      data_type   : Integer;
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
           data_type   => Interfaces.C.int (data_type),
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

end Common;
