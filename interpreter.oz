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
declare FindFreeVars
declare SubLists

fun {FindUnion L1 L2}
   local FindUnionHelper in
      fun {FindUnionHelper L1 L2}  
         case L1
         of nil then L2
         [] X|Xr then
            if {List.member X L2} {FindUnion Xr L2}
            else {FindUnion Xr X|L2}
            end
         end
      end
      {FindUnionHelper {FindUnionHelper L1 L2} nil}
   end
end

fun {SubLists L1 L2} % Subtract L1 from L2
   case L1
   of nil then L2
   [] Li|Lr then {SubLists Lr {List.subtract L2 Li}}
   end
end

fun {FindFreeVars S }
   case S
   of S1|S2 then {FindUnion {FindFreeVars S1} {FindFreeVars S2}}
   [] [bind ident(X) ident(Y)] then (ident(X) | ident(Y) | nil)
   [] [bind ident(X) V] then [X]
   [] [localvar ident(X) S] then {List.subtract {FindFreeVars S} X}
   [] [conditional ident(X) S1 S2] then {FindUnion {FindUnion [X] {FindFreeVars S1}} {FindFreeVars S2}}
   [] [match ident(X) P1 S1 S2] then {FindUnion {FindUnion [X] {FindFreeVars S1}} {FindFreeVars S2}} % Assuming P1 will not have any free vars
   [] [procedure L S] then  {SubLists L S}
   [] [record L Pairs] then {FindUnion {List.Map Pairs fun {$ X} X.2.1 end} nil}
   else nil
   end
end

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
         case V
         of [procedure L S] then  %Part5b
            local FreeVars in
               FreeVars = {List.Map {FindFreeVars Statement} fun {$ X}
                                                                case X
                                                                of ident(Y)
                                                                   Y|E.Y
                                                                end end}
               {Unify ident(X) [procedure L S FreeVars]}
            end
         else
            {Unify ident(X) V}
         end
         {Execution}
	 
	 %Part 6
      [] [conditional ident(X) S1 S2] then
	 local Val in
	    Val = {RetreiveFromSAS X}
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

	 
	 %Part 7
      [] [match ident(X) P1 S1 S2] then
            
      end
   end
end

{Browse {Execution}}
