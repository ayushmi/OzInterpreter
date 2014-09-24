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
declare SASCounter
SAS = {Dictionary.new}
SASCounter = {Cell.new 0}

%Environment - Record with features as variables. Feature values as SAS keys.
declare InitialEnvironment
IntialEnvironment = environment()

%================
%Procedures
%================
%proc {BindValueToKeyInSAS Key Val}
<<<<<<< HEAD
end
=======
%end
>>>>>>> 761aafc00329ea0ebd504c80de1a6c14d47ee1aa

%proc {BindRefToKeysInSAS Key RefKey}
%end

%================
%Functions
%================
declare
fun {AddKeyToSAS}
   local CurrentCounter in
      {Cell.access SASCounter CurrentCounter} 
      {Dictionary.put SAS CurrentCounter nil}
      {Cell.assign SASCounter CurrentCounter + 1}
      CurrentCounter + 1
   end
end

declare
fun {RetrieveFromSAS Key}
   local KeyVal in
      {Dictionary.get SAS Key KeyVal}
      if KeyVal == nil then equivalence(Key)
      else KeyVal end
      
   end
end

{Browse {AddKeyToSAS}}
{Browse try {RetrieveFromSAS 0} catch X then X end}

