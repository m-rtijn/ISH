-- ISH Protocol (client)

-- Get the side of the modem
write("modem side = ")
modem_side = io.read()
write("Hostname = ")
hostname = io.read()
protocol = "ISH"

-- Check modem
print("Checking modem...")
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

-- ~Client Specific code~

-- Get the ID of the slave
write("Slave = ")
slave = io.read()
slaveID = rednet.lookup(protocol, slave)

while true do
  write("<ish@" .. slave .. "> ")
  remoteCmd = io.read()
  if remoteCmd == "exit" then
    break
  end
  args = {}
  for arg in remoteCmd:gmatch("%w+") do
    table.insert(args, arg)
  end
  rednet.send(slaveID, args, protocol)
  senderID, recvMsg, protocol = rednet.receive(protocol, 6000)
  if (senderID == slaveID and recvMsg) then
    print("Succes.")
  else
    print("ERROR: slave did not return succes.")
  end
end

rednet.close()
