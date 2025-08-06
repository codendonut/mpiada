pragma Ada_2022;

with Ada.Command_Line;
with Ada.Text_IO;

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

         res := MPI_Init (argc'Address, argv'Address);
      end;

      if res /= 0 then
         raise Program_Error;
      end if;

      return (Handle => MPI_Comm_f2c (0));
   end Init;

   function Size (comm : MPI_Comm'Class) return Natural is
      res : Integer := 0;
      s   : aliased Interfaces.C.int;
      use Interfaces.C;
   begin
      res := MPI_Comm_size (comm.Handle, s'Address);
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
      r   : aliased Interfaces.C.int;
      use Interfaces.C;
   begin
      res := MPI_Comm_rank (comm.Handle, r'Address);
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

   procedure Finalize is
      res : Integer := 0;
   begin
      res := MPI_Finalize;
      if res /= 0 then
         raise Program_Error;
      end if;
   end Finalize;

end MPI_Ada;
