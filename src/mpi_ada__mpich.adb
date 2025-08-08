with Interfaces.C;

package body MPI_Ada is
   overriding
   function Get_Comm_World return MPI_Comm is
   begin
      return (Handle => 16#44000000#);
   end Get_Comm_World;

end MPI_Ada;
