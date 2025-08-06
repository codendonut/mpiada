with MPI_Ada;
procedure Tests is
   world_comm : MPI_Ada.MPI_Comm;
begin
   world_comm := MPI_Ada.Init;
   pragma Assert (world_comm.Size = 1);
   pragma Assert (world_comm.Rank = 0);

   world_comm.Barrier;
   pragma Assert (True);

   MPI_Ada.Finalize;
   pragma Assert (True);
end Tests;
