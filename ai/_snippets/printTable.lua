-- Function to print a Table
function printTable(table, lvl)
  if type(table) == "table" then
    lvl = lvl or 0
    for k, v in pairs(table) do
      if type(v) == "table" then
        printTable(v, lvl + 1)
      else
        str = ""
        for i = 1,lvl do
          str = str .. "\t"
        end
        print(str, k, v)
      end
    end
  else
    print('Not a table')
  end
end