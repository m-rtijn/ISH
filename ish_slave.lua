-- ISH Protocol (daemon)

-- Get the side of the modem
print("modem side = ")
modem_side = io.read()
print("Hostname = ")
hostname = io.read()
protocol = "ISH"

-- Check the modem
local modem = peripheral.wrap(modem_side)
if modem.isWireless() then
  print("Selected modem is wireless.")
else
  print("Selected modem is wired and will not work with turtles.")
end

-- Check if rednet is open
print("Checking if rednet is open... " .. tostring(rednet.isOpen(modem_side)))
if not rednet.isOpen(modem_side) then
  -- Open rednet
  print("Opening rednet...")
  rednet.open(modem_side)
else
  print("Rednet is already open...")
end

-- Register hostname
print("Registering hostname " .. hostname .. " on protocol " .. protocol)
rednet.host(protocol, hostname)

-- ~Slave Specific code~
print("Start listening...")
while true do
  senderID, args, protocol = rednet.receive(protocol, 600)
  --print("DEBUG: Received cmd from ID " .. tostring(senderID) .. " on protocol " .. tostring(protocol))
  --print(table.getn(args))
  --for i,v in ipairs(args) do
    --print(v)
  --end
  if args[2] == nil then
    shell.run(args[1])
  elseif args[2] ~= nil then
    if args[3] == nil then
      shell.run(args[1], args[2])
    elseif args[4] == nil then
      shell.run(args[1], args[2], args[3])
    end
  else
    shell.run(args[1])
  end
end
