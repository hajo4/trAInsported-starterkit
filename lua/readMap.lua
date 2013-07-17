function readMap (file)
  local map = {}
  map[0] = nil
  map[1] = "C"
  map[2] = "S"
  map[3] = "H"
  map[4] = "STORE"

  local fp = assert(io.open (file))
  local csv = {}
  for line in fp:lines() do
    local row = {}
    for value in line:gmatch("[^ ]*") do -- note: doesn\'t work with strings that contain , values
      row[#row+1] = map[value]
    end
    csv[#csv+1] = row
  end
  -- csv contains now rows / colums from the csv file, i.e.
  return csv
end