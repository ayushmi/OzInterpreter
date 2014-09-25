%=================================
% CS350 Assignment 2
%  Kernel Language
% Authors: Ayush Mittal
%          Ankush Sachdeva
%          Harshvardhan Sharma
%=================================

\insert 'SingleAssignmentStore.oz'
\insert 'Unify.oz'

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

%declare InitialEnvironment
%InitialEnvironment = {Dictionary.new}

%Environment is a record with variables as features and SAS keys as feature values.
%Initially environment is empty.
declare InitialEnvironment
InitialEnvironment = environment()

SemanticStack := {List.append [semanticStatement(StatementList InitialEnvironment)] (@SemanticStack)}

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

	 %PART 2
      [] [localvar ident(X) S] then

	 {Browse X}
	 
	 %Put X to the Environment
	 % and Add Key for X to SAS
	 % and Push S to the SemanticStack with new environment
	 SemanticStack := {List.append [semanticStatement(S {Adjoin Environment environment(X:{AddKeyToSAS})} )] (@SemanticStack)}

	 %Continue with Execution
	 {Execution}

	 %PART 3
      [] [bind ident(X) ident(Y)] then

	 %Call Unify
	 {Unify ident(X) ident(Y) E}

	 %Continue with execution
	 {Execution}

         %Part 5
      [] [bind ident(X) V] then
	 {Unify ident(X) V}
	 {Execution}
	 
	 %Part 6
      [] [conditional ident(X) S1 S2] then
	 local Val in
	    Val = {RetrieveFromSAS X}
	    if Val == literal(t) then
	       SemanticStack := {List.append [semanticStatement(S1 E)] (@SemanticStack)}
	    else
	       if Val == literal(f) then
		    SemanticStack := {List.append [semanticStatement(S2 E)] (@SemanticStack)}
	       else
		  {Browse error} %Probably need to raise an exception here
	       end
	    end
	 end
	 {Execution}

	 
      [] [match ident(X) P1 S1 S2] then
         try
            local NewEnv AddNewIdents in
                fun {AddNewIdents Xs Env}
                    case Xs
                    of nil then Env
                    [] X|Xr then {AddNewIdents Xr {Adjoin Env env(X.2.1:{AddKeyToSAS})}} end
                end
                NewEnv = {AddNewIdents P1.2.2.1 E}
                {Unify ident(X) P1 NewEnv}
	        SemanticStack := {List.append [semanticStatement(S1 NewEnv)] (@SemanticStack)}
            end
         catch
	    SemanticStack := {List.append [semanticStatement(S2 E)] (@SemanticStack)}
         end
         {Execution}


         end
      end  
	 %Part 7
      [] [match ident(X) P1 S1 S2] then
	 
	 
      end
   end
end

{Browse {Execution}}
