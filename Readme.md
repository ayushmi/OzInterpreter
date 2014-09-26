CS350 - Principle of Programming Languages
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

1.1.1 *SingleAssignmentStore*

- A dictionary of Key#Value pairs. 
- Keys are numbers. 
- Values are oz structures which could be any of:
  (a) numbers or records,
  (b) reference(X): used for a refernece of chain of variables.
  (c) equivalence(X): Represents the value that X is unbound. This has to be guaranteed to be equal for two keys in the same equivalence class.

1.1.2 *Environment*

A record. The features are the variables. The feature values are the SAS keys. (Look source of SubstituteIdentifiers function in Unify.oz)

1.2 *Procedures*

1.2.1 *{BindValueToKeyInSAS Key Val}* : If key is unbound (value is part of an equivalence set) bind Val to a key in the SAS. Should raise an exception alreadyAssigned(Key Val CurrentValue) if key is bound.

1.2.2 *{BindRefToKeyInSAS Key RefKey}* : If the key is unbound, then bind a reference to another key to a key in the SAS.

1.3 *Functions*

1.3.1 *{AddKeyToSAS}* : Add a key to Single Assignment Store. This will return the key that you can associate with your identifier and later assign a value to.

1.3.2 *{RetrieveFromSAS Key}* : Retrieve a value from the single assignment store. This will raise an exception if the key is missing from the SAS. For unbound keys, this will return equivalence(Key) - this is guaranteed to be same for two keys in the same equivalence set.

2. In Unify.oz we already have the following procedure:

2.1 *{Unify Expression1 Expression2 Environment}* : Unify Expression1 and Expression2 given the mappings in the Environment. Unification Error will be raise an incompatibleTypes exception.

3. interpreter.oz

3.1 Interpreter.oz has *{Execution}* function. This function performs the execution on the semantic stack. 

3.2 The *{FindFreeVars}* function is used by the *{Execution}* for finding free variables in a statement for lexical scoping.
