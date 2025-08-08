with Common;

package MPI_Ada is
   type MPI_Comm is new Common.MPI_Comm_Base with null record;

   overriding
   function Get_Comm_World return MPI_Comm;

   procedure Init (program_name : String) renames Common.Init;
   procedure Finalize renames Common.Finalize;

end MPI_Ada;
