-- ISH Protocol (daemon)

-- Get the side of the modem
write("modem side = ")
modem_side = io.read()
write("Hostname = ")
hostname = io.read()
protocol = "ISH"

-- Check the modem
print("Checking modem...")
local modem = peripheral.wrap(modem_side)
wireless = modem.isWireless()
if wireless then
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

-- ~Daemon Specific code~
print("Start listening...")
while true do
  senderID, args, protocol = rednet.receive(protocol, 600)
  for i,v in ipairs(args) do
    write(v .. " ")
  end
  if args[2] == nil then
    result = shell.run(args[1])
    rednet.send(senderID, result, protocol)
  elseif args[2] ~= nil then
    if args[3] == nil then
      resutl = shell.run(args[1], args[2])
      rednet.send(senderID, result, protocol)
    elseif args[4] == nil then
      result = shell.run(args[1], args[2], args[3])
      rednet.send(senderID, result, protocol)
    end
  else
    result = shell.run(args[1])
    rednet.send(senderID, result, protocol)
  end
end

rednet.close()
