with Ada.Command_Line;
with API;

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

         res :=
           API.MPI_Init
             (API.C_Int_Ptr (argc'Address), API.Argv_Ptr (argv'Address));
      end;

      if res /= 0 then
         raise Program_Error;
      end if;

   end Init;

   procedure Finalize is
      res : Integer := 0;
   begin
      res := API.MPI_Finalize;
      if res /= 0 then
         raise Program_Error;
      end if;
   end Finalize;

end MPI_Ada;
