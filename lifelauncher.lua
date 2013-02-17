print("Downloading latest version from github...")
local fh=http.get("https://raw.github.com/Sxw1212/cclife/master/life.lua")
if fh then
local code=fh.readAll()
fh.close()
print("Launching...")
for k,v in pairs(rs.getSides()) do
if peripheral.getType(v)=="monitor" then
print("Monitor found...")
local monitor=true
local monitorc=v
end
end
if monitor then
term.clear()
term.setCursorPos(1,1)
print("Monitor detected. Enable?")
write("yes/no[yes]:")
local ans=read()
if ans=="yes" or ans=="" then
print("Monitor enabled!")
mon=peripherial.wrap(monitorc)
term.redirect(mon)
pcall(loadstring,code)
term.restore()
else
loadstring(code)
end
else
loadstring(code)
end
print("Exited")
else
print("Failed to download new version")
end