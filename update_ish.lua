ish_url = "http://raw.githubusercontent.com/Tijndagamer/ISH/master/"
ishd_url = ish_url .. "ishd.lua"
ish_client_url = ish_url .. "ish_client.lua"

local function get (url)
  write("Connecting to " .. url .. " ... ")
  local response = http.get(url)
  if response then
    print("Success.")
    local contents = response.readAll()
    response.close()
    return contents
  else
    print("Failed.")
  end
end

local function save (filename, contents)
  if fs.exists(filename) then
    print("File already exists, overwriting...")
    fs.delete(filename)
  end
  if contents then
    local file = fs.open(filename, "w")
    file.write(contents)
    file.close()
  else
    print("Error opening file")
  end
end

save("/ishd", get(ishd_url))
save("/ish_client", get(ish_client_url))
