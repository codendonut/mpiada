with Ada.Text_IO;
with MPI_Ada;
with Comm;
with Datatype;
with API;
with MPI_Ada.Constants; use MPI_Ada.Constants;

procedure Tests is
   world_comm    : Comm.MPI_Comm;
   local_rank    : Natural := 0;
   local_size    : Natural := 0;
   init_str      : constant String := "Hello World";
   result_str    : String (1 .. init_str'Length) := "ZZZZZ ZZZZZ";
   result_status : API.MPI_Status;

begin
   MPI_Ada.Init ("tests");
   world_comm := MPI_COMM_WORLD;

   Ada.Text_IO.Put_Line ("Init - SUCCESS");
   local_rank := world_comm.Rank;
   pragma Assert (local_rank >= 0 and then local_rank <= 2);
   Ada.Text_IO.Put_Line ("Rank" & local_rank'Image & " - SUCCESS");

   local_size := world_comm.Size;
   pragma Assert (local_size >= 1 and then local_size <= 3);
   if local_rank = 0 then
      Ada.Text_IO.Put_Line ("Size" & local_size'Image & " - SUCCESS");
   end if;

   world_comm.Barrier;
   pragma Assert (True);
   if local_rank = 0 then
      Ada.Text_IO.Put_Line ("Barrier - SUCCESS");
   end if;

   if local_size > 1 then
      if local_rank = 0 then
         world_comm.Send
           (dest_rank => 1,
            tag       => 99,
            count     => init_str'Length,
            data_type => Datatype.MPI_CHAR,
            msg       => init_str);
      elsif local_rank = 1 then
         result_str :=
           world_comm.Recv
             (source_rank => 0,
              tag         => 99,
              count       => init_str'Length,
              data_type   => Datatype.MPI_CHAR,
              status      => result_status);
         Ada.Text_IO.Put_Line (result_str);
         pragma Assert (result_str = "Hello World");
      end if;
   end if;

   MPI_Ada.Finalize;
   pragma Assert (True);
   if local_rank = 0 then
      Ada.Text_IO.Put_Line ("Finalize - SUCCESS");
   end if;

end Tests;
