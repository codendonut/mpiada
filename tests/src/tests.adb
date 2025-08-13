with Ada.Text_IO;
with MPI_Ada;           use MPI_Ada;
with MPI_Ada.Constants; use MPI_Ada.Constants;
with MPI_Ada.Generic_Ops;

procedure Tests is
   package io renames Ada.Text_IO;

   local_rank    : Natural := 0;
   local_size    : Natural := 0;
   init_str      : constant String := "Hello World";
   result_str    : String (1 .. init_str'Length);
   result_status : MPI_Status;
   mpi_call_res  : Integer;

   package ops is new
     Generic_Ops (T => String, Index => Positive, Element => Character);
   use ops;
begin
   mpi_call_res := MPI_Init ("tests");
   pragma Assert (mpi_call_res = 0);
   io.Put_Line ("Init - SUCCESS");

   mpi_call_res := MPI_Comm_rank (MPI_COMM_WORLD, local_rank);
   pragma Assert (mpi_call_res = 0);
   pragma Assert (local_rank >= 0 and then local_rank <= 2);
   io.Put_Line ("Rank" & local_rank'Image & " - SUCCESS");

   mpi_call_res := MPI_Comm_size (MPI_COMM_WORLD, local_size);
   pragma Assert (mpi_call_res = 0);
   pragma Assert (local_size = 2);
   if local_rank = 0 then
      io.Put_Line ("Size" & local_size'Image & " - SUCCESS");
   end if;

   mpi_call_res := MPI_Barrier (MPI_COMM_WORLD);
   pragma Assert (mpi_call_res = 0);
   if local_rank = 0 then
      io.Put_Line ("Barrier - SUCCESS");
   end if;

   if local_rank = 0 then
      mpi_call_res :=
        MPI_Send
          (dest_rank   => 1,
           message_tag => 99,
           count       => init_str'Length,
           data_type   => MPI_CHAR,
           comm_handle => MPI_COMM_WORLD,
           buf         => init_str);
      pragma Assert (mpi_call_res = 0);

   elsif local_rank = 1 then
      mpi_call_res :=
        MPI_Recv
          (source_rank => 0,
           message_tag => 99,
           count       => init_str'Length,
           data_type   => MPI_CHAR,
           buf_out     => result_str,
           comm_handle => MPI_COMM_WORLD,
           status_out  => result_status);
      pragma Assert (mpi_call_res = 0);
      io.Put_Line (result_str);
      pragma Assert (result_str = "Hello World");
   end if;

   mpi_call_res := MPI_Finalize;
   pragma Assert (mpi_call_res = 0);
   if local_rank = 0 then
      io.Put_Line ("Finalize - SUCCESS");
   end if;

end Tests;
