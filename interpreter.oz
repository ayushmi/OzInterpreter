%=================================
% CS350 Assignment 2
%  Kernel Language
% Authors: Ayush Mittal
%          Ankush Sachdeva
%          Harshvardhan Sharma
%=================================


%SemanticStack is a list of pairs of Statement and Environment.
declare 
SemanticStack = {NewCell nil}

declare StatementList
%StatementList = [[nop] [nop] [nop]]
%StatementList = [[nop] [localvar ident(x) [localvar ident(y) [nop]]]]
StatementList = [[nop] [localvar ident(x)
       [localvar ident(y)
              [localvar ident(x)
	       [nop]]]]]

declare InitialEnvironment
InitialEnvironment = {Dictionary.new}

SemanticStack := {List.append [semanticStatement(StatementList InitialEnvironment)] (@SemanticStack)}

%Stores next free name in SAS
declare Count
Count = {NewCell 0}

declare SAS
SAS = {Dictionary.new}


declare Execution
fun {Execution}
   local Statement Environment in
      
      %Pop Stament,Environment from Semantic Stack 
      case @SemanticStack
      of nil then
	 Statement = nil
	 Environment = nil
      else
	 Statement = (@SemanticStack).1.1
	 Environment = (@SemanticStack).1.2
	 SemanticStack := (@SemanticStack).2
      end
      
      case Statement
      of nil then nil
	 
      [] nop|nil then              %if nop then skip
	 {Browse nop}
	 {Execution}

	 
      [] (S1|S1Left)|S2 then       %In case of S1|S2 push S2 to stack then S1 to stack

         %Push S2 on to stack
	 case S2
	 of nil then skip
	 else
	    SemanticStack := {List.append [semanticStatement(S2 Environment)] @SemanticStack}
	 end

         %Push S1 on to stack
	 SemanticStack := {List.append [semanticStatement((S1|S1Left) Environment)] @SemanticStack}

	 %Continue with execution
	 {Execution}

      [] [localvar ident(X) S] then

	 {Browse X}
	 
	 %Put X to the Environment
	 {Dictionary.put Environment X @Count}
	 

	 %Add Key for X to SAS
	 {Dictionary.put SAS @Count nil}
	 Count := @Count+1
	  
	 %Push S to the SemanticStack with new environment
	 SemanticStack := {List.append [semanticStatement(S Environment)] (@SemanticStack)}

	 %Continue with Execution
	 {Execution}
	 
      end
   end
end


{Browse {Execution}}