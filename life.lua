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
function getStat(cell, x, y)
w,h=term.getSize()
h=h-1

fx, fy=0

if x==0 then
fx=w
end
if y==0 then
fy=h
end
if y==h then
fy=1
end
if x==w then
fx=1
end
if fx==0 then
fx=x
end
if fy==0 then
fy=y
end
return cell[fx][fy]
end
function Evolve( cell )
	local newcell={}
	local width=#cell
	local height=#cell[1]
	for x,xv in pairs(cell) do
		newcell[x]={}
		for y,yv in pairs(xv) do
			--Get surrouding
			local s=0
			local cs=getStat(cell,x,y)
			--Top 3
			s=s+getStat(cell, x-1, y+1)
			s=s+getStat(cell, x, y+1)
			s=s+getStat(cell, x+1, y+1)
			--Middle 2
			s=s+getStat(cell, x-1, y)
			s=s+getStat(cell, x+1, y)
			--Bottom 3
			s=s+getStat(cell, x-1, y-1)
			s=s+getStat(cell, x, y-1)
			s=s+getStat(cell, x+1, y-1)
			--Deciding
			if s==3 then
			newcell[x][y]=1
			elseif s==2 and cs==1 then
			newcell[x][y]=1
			else
			newcell[x][y]=0
			end
			
		end
	end
    return newcell
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