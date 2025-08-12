with API;

package MPI_Ada is

   procedure Finalize;
   procedure Init (program_name : String);

private

   function MPI_Init
     (argc : API.C_Int_Addr; argv : API.Argv_Addr) return Integer
   with Import => True, Convention => C, External_Name => "MPI_Init";

   function MPI_Finalize return Integer
   with Import => True, Convention => C, External_Name => "MPI_Finalize";

end MPI_Ada;
