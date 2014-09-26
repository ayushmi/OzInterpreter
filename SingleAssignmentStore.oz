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
proc {BindValueToKeyInSAS Key Val}
    if {Dictionary.get SAS Key} == equivalence(Key) then
        {Dictionary.put SAS Key Val}
    else
        raise alreadyAssigned(Key Val {Dictionary.get SAS Key}) end
    end
end

proc {BindRefToKeyInSAS Key RefKey}
    {Dictionary.put SAS Key reference(RefKey)}
end

%================
%Functions
%================
declare
fun {AddKeyToSAS}
   local CurrentCounter in
      {Cell.access SASCounter CurrentCounter} 
      {Dictionary.put SAS CurrentCounter equivalence(CurrentCounter)}
      {Cell.assign SASCounter CurrentCounter + 1}
      CurrentCounter + 1
   end
end

declare
fun {RetrieveFromSAS Key}
   local KeyVal in
      {Dictionary.get SAS Key KeyVal}
      case KeyVal
      of reference(KeyVal2) then {RetrieveFromSAS KeyVal2}
      else KeyVal end
   end
end

{Browse {AddKeyToSAS}}
{Browse try {RetrieveFromSAS 0} catch X then X end}

