with System;

package API is
   type MPI_Struct is null record;
   type Handle is new System.Address;
   type MPI_Comm_Handle is new Handle;
   type MPI_Datatype_Handle is new Handle;

   type MPI_Addr is new System.Address;
   type MPI_Status_Addr is new MPI_Addr;
   type C_Int_Addr is new MPI_Addr;
   type Argv_Addr is new MPI_Addr;

   type Message_Addr is new MPI_Addr;

end API;
