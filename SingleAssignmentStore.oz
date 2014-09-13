%=================================
% CS350 Assignment 2
% SingleAssignmentStore.oz
% Authors: Ayush Mittal
%          Ankush Sachdeva
%          Harshvardhan Sharma
%=================================

%================
%DataStructures
%================

%SAS - keys are numbers and values are oz structures.
declare SAS
SAS = {Dictionary.new}

%Environment - Record with features as variables. Feature values as SAS keys.
declare InitialEnvironment
IntialEnvironment = environment()

%================
%Procedures
%================
proc {BindValueToKeyInSAS Key Val}
end

proc {BindRefToKeysInSAS Key RefKey}
end

%================
%Functions
%================
declare
fun {AddKeyToSAS}
end

declare
fun {RetrieveFromSAS Key}
end