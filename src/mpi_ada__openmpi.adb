with Interfaces.C;

package body MPI_Ada is

   function MPI_Comm_f2c
     (comm_handle_in : Interfaces.C.int) return Common.MPI_Comm_Handle
   with Import => True, Convention => C, External_Name => "MPI_Comm_f2c";

   overriding
   function Get_Comm_World return MPI_Comm is
   begin
      return (Handle => MPI_Comm_f2c (0));
   end Get_Comm_World;

end MPI_Ada;
