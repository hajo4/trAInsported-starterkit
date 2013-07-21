function readMap (file)
  local map = {}

  -- Codierung
  map[0] = nil
  map[1] = "C"
  map[2] = "S"
  map[3] = "H"
  map[4] = "STORE"

  local fp = assert(io.open (file))
  local csv = {}
  j = 1
  for line in fp:lines() do
    local row = {}
    i = 1
    for token in string.gmatch(line, "[^%s]+") do
      row[i] = map[tonumber(token)]
      i = i+1
    end
    csv[j] = row
    j = j+1
    
  end
  -- csv contains now rows / colums from the csv file, i.e.
  return csv
end