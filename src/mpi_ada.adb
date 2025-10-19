with Ada.Command_Line;
with Ada.Strings.Fixed;

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

   function MPI_Init (program_name : String) return Integer is
      argc        : Natural := cmd.Argument_Count;
      longest_len : Natural := program_name'Length;
   begin
      if argc > 1 then
         longest_len := Positive'Max (longest_len, Find_Longest_Length (argc));
      end if;

      declare
         argv :
           array (Positive range 1 .. argc + 1) of String (1 .. longest_len);
      begin
         argv (1) := program_name;

         for i in 1 .. argc loop
            Ada.Strings.Fixed.Move
              (Source => cmd.Argument (i), Target => argv (i + 1));
         end loop;

         argc := argc + 1;

         pragma Assert (argv'Length = argc);

         return
           Funcs.MPI_Init
             (API.C_Int_Addr (argc'Address), API.Argv_Addr (argv'Address));
      end;
   end MPI_Init;

   function MPI_Comm_size
     (comm : API.MPI_Comm_Handle; size : out Integer) return Integer is
   begin
      return Funcs.MPI_Comm_size (comm, API.C_Int_Addr (size'Address));
   end MPI_Comm_size;

   function MPI_Comm_rank
     (comm : API.MPI_Comm_Handle; rank : out Integer) return Integer is
   begin
      return Funcs.MPI_Comm_rank (comm, API.C_Int_Addr (rank'Address));
   end MPI_Comm_rank;

end MPI_Ada;
