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
shell.run("monitor", monitorc, x)
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
	local newcell={}
	local actions={}
	local width=#cell
	local height=#cell[1]
	for x,xv in pairs(cell) do
		newcell[x]={}
		for y,yv in pairs(xv) do
			local s=0
			--Get surrounding
			--x+1
			if x==width then
			s=s+cell[1][y]
			else
			s=s+cell[x+1][y]
			end
			--x-1
			if x==1 then
			s=s+cell[width][y]
			else
			s=s+cell[x-1][y]
			end
			--y+1
			if x==height then
			s=s+cell[x][1]
			else
			s=s+cell[x][y+1]
			end
			--y-1
			if y==1 then
			s=s+cell[x][height]
			else
			s=s+cell[x][y-1]
			end
			--Decide its fate...
			if s==3 or s==2 then
			newcell[x][y]=1
			elseif s==4 or s==0 then
			newcell[x][y]=0
			end
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

c={}
for i=1,x do
c[i]={}
for j=1, y-1 do
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
draw()
end
elseif e=="mouse_click" then
handleclick(p2,p3)
draw()
elseif e=="mouse_drag" then
handleclick(p2,p3)
draw()
elseif e=="key" then
paused=not paused
draw()
end
end