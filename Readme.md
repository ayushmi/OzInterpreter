CS350 - Principle f Programming Languages
=========================================
Assignment 2 - Oz interpreter
-----------------------------

In this Assignment for Priciples of Programming Language Course, we implemented a simple interpreter for the declarative sequential model discussed in the second chapter of book.

The assignment is implemented in oz.

The code assumes that the input is given in the Abstract Syntax Tree format.
The program outputs the sequence of the execution states during the execution of the statement.

### Deatils of the code:

1. We were already provided with the Unify.oz file. Unify.oz requires a file called "SingleAssignmentStore.oz", which has to provide the following:

1.1 *Data Structures* 

1.1.1 __SingleAssignmentStore__

- A dictionary of Key#Value pairs. 
- Keys are numbers. 
- Values are oz structures which could be any of:
  (a) numbers or records,
  (b) reference(X): used for a refernece of chain of variables.
  (c) equivalence(X): Represents the value that X is unbound. This has to be guaranteed to be equal for two keys in the same equivalence class.

1.1.2 __Environment__

A record. The features are the variables. The feature values are the SAS keys. (Look source of SubstituteIdentifiers function in Unify.oz)

1.2 *Procedures*

1.2.1 __{BindValueToKeyInSAS Key Val}__ : If key is unbound (value is part of an equivalence set) bind Val to a key in the SAS. Should raise an exception alreadyAssigned(Key Val CurrentValue) if key is bound.
