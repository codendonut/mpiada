with Ada.Text_IO;
with MPI_Ada;

procedure Tests is
   world_comm : MPI_Ada.MPI_Comm;
   local_rank : Natural := 0;
   local_size : Natural := 0;
begin
   MPI_Ada.Init ("tests");
   world_comm := MPI_Ada.Get_Comm_World;

   Ada.Text_IO.Put_Line ("Init - SUCCESS");
   local_rank := world_comm.Rank;
   pragma Assert (local_rank >= 0 and then local_rank <= 2);
   Ada.Text_IO.Put_Line ("Rank" & local_rank'Image & " - SUCCESS");

   local_size := world_comm.Size;
   pragma Assert (local_size >= 1 and then local_size <= 3);
   if local_rank = 0 then
      Ada.Text_IO.Put_Line ("Size" & local_size & " - SUCCESS");
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
