with API;

package Datatype is
   type MPI_Datatype is tagged record
      Handle : API.MPI_Datatype_Handle;
   end record;

   function MPI_CHAR return MPI_Datatype;
end Datatype;
