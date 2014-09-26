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
declare Map
declare FoldR
fun {FoldR F Xs Partial}
   case Xs
   of nil then Partial
    [] X|Xr then {F X {FoldR F Xr Partial}}
   end
end
fun {Map F Xs}
   {FoldR fun{$ A B} {F A}|B end Xs nil}
end

declare StatementList
%StatementList = [[nop] [nop] [nop]]
%StatementList = [[nop] [localvar ident(x) [localvar ident(y) [nop]]]]
%StatementList = [[nop] [localvar ident(x)
%       [localvar ident(y)
%              [localvar ident(x)
%	       [nop]]]]]
%StatementList = [
%                 [localvar ident(x) [localvar ident(g) [localvar ident(e) [
%                                                                           [bind ident(x)
%                                                                            [procedure [ident(t)]
 %                                                                            [
 %                                                                             [localvar ident(z) [
 %                                                                                                 [bind ident(g) literal(2)]
 %                                                                                                ]
 %                                                                             ]
 %                                                                            ]
 %                                                                           ]
 %                                                                          ]
 %                                                                          [apply ident(x) ident(e)]
 %                                                                         ]
 %                                                      ]
 %                                   ]
 %                ]
%                ]
%StatementList = [
%                 [
%                  localvar ident(x)[
%                                    localvar ident(a) [
%                                                       localvar ident(b) [
%                                                                          [bind ident(x) [record literal(name) [
%                                                                                                                [literal(1) ident(a)]
%                                                                                                                [literal(2) ident(b)]
%                                                                                                               ]
%                                                                                         ]
%                                                                          ]
%                                                                          [match ident(x)
%                                                                           [record literal(name) [
%                                                                                                  [literal(3) ident(c)]
%                                                                                                  [literal(1) ident(d)]
%                                                                                                 ]
%                                                                           ]
%                                                                           [
%                                                                            nop
%                                                                           ]
%                                                                           [
%                                                                            [nop][nop]
%                                                                           ]
%                                                                          ]
%                                                                         ]
%                                                      ]
%                                   ]
%                 ]
%                ]
StatementList = [ localvar ident(x)[
                   localvar ident(y) [
                  localvar ident(z)   [
                                       [bind ident(x) ident(z)]
                                       [bind ident(y) (f)]
                                       [conditional ident(y)
                                          [bind ident(z) 2]
                                          [bind ident(z) 3]
                                       ]
                                       %[bind ident(x) 1]
                                       %[apply ident(p) ident(x) ident(y)]
                                      ]
                                     ]
                                   ]
                ]
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
            if {List.member X L2} then {FindUnionHelper Xr L2}
            else {FindUnionHelper Xr X|L2}
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
   of (S1|S1Left)|S2 then {FindUnion {FindFreeVars (S1|S1Left)} {FindFreeVars S2}}
   [] [bind ident(X) ident(Y)] then (ident(X) | ident(Y) | nil)
   [] [bind ident(X) V] then {FindUnion {FindFreeVars V} [ident(X)]}
   [] [localvar ident(X) S] then {List.subtract {FindFreeVars S} ident(X)}
   [] [conditional ident(X) S1 S2] then {FindUnion {FindUnion [ident(X)] {FindFreeVars S1}} {FindFreeVars S2}}
   [] [match ident(X) P1 S1 S2] then {FindUnion {FindUnion [ident(X)] {FindFreeVars S1}} {FindFreeVars S2}} % Assuming P1 will not have any free vars
   [] [procedure L S] then  {SubLists L {FindFreeVars S}}
   [] [record L Pairs] then {FindUnion {Map fun {$ X} X.2.1 end Pairs} nil}
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
      {Browse Statement}
      {Browse Environment}
      case Statement
      of nil then nil
	 
      [] nop|nil then              %if nop then skip
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
	 
	 %Put X to the Environment
	 % and Add Key for X to SAS
	 % and Push S to the SemanticStack with new environment
	 SemanticStack := {List.append [semanticStatement(S {Adjoin Environment environment(X:{AddKeyToSAS})} )] (@SemanticStack)}
         
	 %Continue with Execution
	 {Execution}

	 %PART 3
      [] [bind ident(X) ident(Y)] then

	 %Call Unify
	 {Unify ident(X) ident(Y) Environment}

	 %Continue with execution
	 {Execution}

         %Part 5
      [] [bind ident(X) V] then
         case V
         of [procedure L S] then  %Part5b
            local FreeVars in
               FreeVars = {Map fun {$ X}
                                                                      {Browse X}
                                                                      case X
                                                                      of ident(Y)
                                                                      then [Y Environment.Y]
                                                                      end end
                           {SubLists L {FindFreeVars S}}
                          }
               {Browse FreeVars}
               {Unify ident(X) [procedure L S FreeVars] Environment}
               {Browse unifyDone}
            end
         else
            {Unify ident(X) V Environment}
         end
         {Execution}
	 
	 %Part 6
      [] [conditional ident(X) S1 S2] then
	 local Val in
	    Val = {RetrieveFromSAS Environment.X}
	    if Val == literal(t) then
	       SemanticStack := {List.append [semanticStatement(S1 Environment)] (@SemanticStack)}
	    else
	       if Val == literal(f) then
		    SemanticStack := {List.append [semanticStatement(S2 Environment)] (@SemanticStack)}
	       else
		  raise literalIsNotBoolean(X) end %Probably need to raise an exception here
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
                  [] [literal(A) ident(X)]|Xr then {AddNewIdents Xr {Adjoin Env environment(X : {AddKeyToSAS})}}
                  end
               end
               case P1 of [record L Pairs] then
                  NewEnv = {AddNewIdents Pairs Environment}
               end
               {Browse [newEnv NewEnv]}
               {Unify ident(X) P1 NewEnv}
               SemanticStack := {List.append [semanticStatement(S1 NewEnv)] (@SemanticStack)}
               {Browse notCaught}
               
            end
         catch E then
            {Browse caught}
            
            SemanticStack := {List.append [semanticStatement(S2 Environment)] (@SemanticStack)}
           
            
         end
         {Execution}
         
      [] apply | ident(X) | L then
         local Y AddFormal NewEnv AddFreeVars in
            fun {AddFormal Xs Env}
               {Browse addFormalStarted}
               case Xs
               of nil then Env
               [] ident(X) | Xr then {AddFormal Xr {Adjoin Env environment(X : {AddKeyToSAS})}} end
            end
            fun {AddFreeVars Xs Env}
               {Browse addFreeVars}
               case Xs
               of nil then Env
               [] [X Y]|Xr then {AddFreeVars Xr {Adjoin Env environment(X : Y)}} end
            end
            Y = {RetrieveFromSAS Environment.X}
            {Browse [gotY Y]}
            case Y
            of [procedure L S FreeVars] then
              NewEnv = {Adjoin {AddFormal L nil} {AddFreeVars FreeVars nil}}
               {Browse [newEnv NewEnv]}
              SemanticStack := {List.append [semanticStatement(S NewEnv)] (@SemanticStack)}
            else
              raise functionNotDefined(X) end
            end
         end
         {Execution}
      else raise syntaxError(Statement) end
      end
   end  
end

{Browse {Execution}}
{Browse over}
