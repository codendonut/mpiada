with System;
with Interfaces.C;

package API is
   type MPI_Status is record
      Source : Integer;
      Tag    : Integer;
      Error  : Integer;
   end record;

   type MPI_Struct is null record;
   type Handle is new System.Address;
   type MPI_Comm_Handle is new Handle;
   type MPI_Datatype_Handle is new Handle;

   type MPI_Addr is new System.Address;
   type MPI_Status_Addr is new MPI_Addr;
   type C_Int_Addr is new MPI_Addr;
   type Argv_Addr is new MPI_Addr;

   type Message_Addr is new MPI_Addr;

   type MPI_Internal_Arr is
     array (Interfaces.C.int range 0 .. 4) of Interfaces.C.int;

   type MPI_Status_C is tagged record
      MPI_SOURCE   : Interfaces.C.int;
      MPI_TAG      : Interfaces.C.int;
      MPI_ERROR    : Interfaces.C.int;
      MPI_internal : MPI_Internal_Arr;
   end record
   with Convention => C;

end API;
