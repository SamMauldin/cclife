args={...}
monitor=false
monitorc=""
if args[1]=="monitor" then
print("Monitor support beta activated!!!")
for k,v in pairs(rs.getSides()) do
if peripheral.getType(v)=="monitor" then
print("Monitor found...")
monitor=true
monitorc=v
term.redirect(peripheral.wrap(monitorc))
end
end
end
updateurl="https://raw.github.com/Sxw1212/cclife/master/life.lua"
if not update then
print("Updating...")
update=true
x=shell.getRunningProgram()
upd=http.get(updateurl)
if upd then
fs.delete(x)
updfh=fs.open(x, "w")
updfh.write(upd.readAll())
updfh.close()
upd.close()
print("Update Completed")
sleep(1)
if monitor then
print("Running with monitor support")
sleep(1)
shell.run(x, "monitor")
else
shell.run(x)
end
return
else
print("Update failed")
print("Using old copy...")
sleep(1)
end
end
if update then
update=false
end
function Evolve( cell )
    local m = #cell
    local cell2 = {}
    for i = 1, m do
        cell2[i] = {}
        for j = 1, m do
            cell2[i][j] = cell[i][j]
        end
    end
 
    for i = 1, m do
        for j = 1, m do
            local count
            if cell2[i][j] == 0 then count = 0 else count = -1 end
            for x = -1, 1 do
                for y = -1, 1 do
                    if i+x >= 1 and i+x <= m and j+y >= 1 and j+y <= m and cell2[i+x][j+y] == 1 then count = count + 1 end
                end
            end
            if count < 2 or count > 3 then cell[i][j] = 0 end
            if count == 3 then cell[i][j] = 1 end
        end
    end
 
    return cell
end

function clear()
term.clear()
term.setCursorPos(1,1)
end
clear()
print "Welcome to Sxw's Game of Life!"
x,y=term.getSize()
term.restore()
size=0
if x > y then
size=y-1
elseif x < y then
size=x
else
size=x-1
end
c={}
for i=1,size do
c[i]={}
for j=1, size do
c[i][j]=0
end
end
function draw(mon)
clear()
for ck,cv in pairs(c) do
for k,v in pairs(cv) do
if v==0 then
paintutils.drawPixel(ck,k, colors.blue)
else
paintutils.drawPixel(ck,k, colors.lime)
end
term.setBackgroundColor(colors.gray)
end
print("")
end
if paused then
term.write("Paused")
else
term.write("Simulating...")
end
if not mon then
if monitor then
term.redirect(peripheral.wrap(monitorc))
draw(true)
term.restore()
end
end
end
function handleclick(p1,p2)
if c[p1] then
if c[p1][p2] then
if c[p1][p2]==0 then
c[p1][p2]=1
else
c[p1][p2]=0
end
return
end
end
paused=not paused
end
paused=true
interval=0.5
os.startTimer(interval)
while true do
e,p1,p2,p3,p4,p5=os.pullEvent()
if e=="timer" then
os.startTimer(interval)
if not paused then
c=Evolve(c)
end
elseif e=="mouse_click" then
handleclick(p2,p3)
elseif e=="mouse_drag" then
handleclick(p2,p3)
elseif e=="monitor_touch" then
handleclick(p2,p3)
elseif e=="key" then
paused=not paused
end
draw()
end