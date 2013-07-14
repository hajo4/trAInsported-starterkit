function Dijkstra(start, finish, nodes)
  --Create a closed and open set
  local open = {}
  local closed = {}
 
  --Attach data to all noded without modifying them
  local data = {}
  for _, node in pairs(nodes) do
    data[node] = {
      distance = math.huge,
      previous = nil
    }
  end
 
  --The start node has a distance of 0, and starts in the open set
  open[start] = true
  data[start].distance = 0
 
  while true do
    --pick the nearest open node
    local best = nil
    for node in pairs(open) do
      if not best or data[o].distance < data[best].distance then
        best = o
      end
    end
 
    --at the finish - stop looking
    if best == finish then break end
 
    --all nodes traversed - finish not found! No connection between start and finish
    if not best then return end
 
    --calculate a new score for each neighbour
    for _, neighbor in ipairs(best:neighbors()) do
      --provided it's not already in the closed set
      if not closed[neighbor] then
        local newdist = data[best].distance + best:distanceTo(neighbor)
        if newdist < data[neighbor].distance then
          data[neighbor].distance = newdist
          data[neighbor].previous = best
        end
      end
    end
 
    --move the node to the closed set
    closed[best] = true
    open[best] = nil
  end
 
  --walk backwards to reconstruct the path
  local path = {}
  local at = finish
  while at ~= start do
    table.insert(path, 0, at)
    at = data[at].previous
  end
 
  return path
end