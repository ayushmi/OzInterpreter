declare Execution
fun {Execution StatementList}
   case StatementList
   of nil then nil
   [] (nop|nil)|Rest then
      {Browse [nop]}
      {Execution Rest}
   end
end

{Browse {Execution [[nop] [nop] [nop]]}}