with Ada.Text_IO;
with MPI_Ada;

procedure Tests is
   world_comm : constant MPI_Ada.MPI_Comm := MPI_Ada.Init;
   local_rank : Natural := 0;
begin
   Ada.Text_IO.Put_Line ("Init - SUCCESS");
   pragma Assert (world_comm.Rank >= 0 and then world_comm.Rank <= 2);
   local_rank := world_comm.Rank;
   Ada.Text_IO.Put_Line ("Rank" & local_rank'Image & " - SUCCESS");

   pragma Assert (world_comm.Size >= 1 and then world_comm.Size <= 3);
   if local_rank = 0 then
      Ada.Text_IO.Put_Line ("Size - SUCCESS");
   end if;

   world_comm.Barrier;
   pragma Assert (True);
   if local_rank = 0 then
      Ada.Text_IO.Put_Line ("Barrier - SUCCESS");
   end if;

   MPI_Ada.Finalize;
   pragma Assert (True);
   if local_rank = 0 then
      Ada.Text_IO.Put_Line ("Finalize - SUCCESS");
   end if;

end Tests;
