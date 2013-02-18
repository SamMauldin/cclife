local c=nil
debug=false
args={...}
stop=false
file=nil
lifec=nil
if #args==1 then
if fs.exists(args[1]) then
print("Loading lifefile...")
file=args[1]
x=fs.open(file, "r")
if x then
lifec=x.readAll()
x.close()
local xc=textutils.unserialize(lifec)
local nlc={}
if xc then
for k,v in pairs(xc) do
nlc[k]=textutils.unserialize(v)
end
c=nlc
else
print("Error reading file")
sleep(1)
stop=true
end
end
else
print("The file "..file.." not found, will be created on save.")
sleep(1)

end
elseif #args==0 then
--Eventually prompt
else
print("Usage: life [file]")
sleep(1)
stop=true
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
function log(msg)
if debug then
print(msg)
end
end
function getStat(cell, x, y)
w,h=term.getSize()
h=h-1
fx=0
fy=0
log("Starting:X:"..x.." Y:"..y)
if x<1 then
log("x is less than 1")
fx=w
end
if y<1 then
log("y is less than 1")
fy=h
end
if y>h then
log("y is greater than h")
fy=1
end
if x>w then
log("x is greater than w")
fx=1
end
if fx==0 then
log("fx is 0")
fx=x
end
if fy==0 then
log("fy is 0")
fy=y
end
log("W:"..w.." H:"..h)
log("X:"..fx.." Y:"..fy)
if not cell[fx][fy] then
return 0
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
			if cs==0 then
			paintutils.drawPixel(x,y, colors.lime)
			end
			newcell[x][y]=1
			elseif s==2 and cs==1 then
			newcell[x][y]=1
			else
			if cs==1 then
			paintutils.drawPixel(x,y, colors.blue)
			end
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
sleep(1)
x,y=term.getSize()
if not c then
c={}
for i=1,x do
c[i]={}
for j=1, y-1 do
c[i][j]=0
end
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
term.setBackgroundColor(colors.orange)
end
print("")
end
if paused then
term.write("Play")
else
term.write("Stop")
end
x,y=term.getSize()
paintutils.drawLine(5,y,x,y,colors.blue)
term.setCursorPos(x-3,y)
term.setBackgroundColor(colors.yellow)
term.write("S")
term.setBackgroundColor(colors.lime)
term.write("R")
term.setBackgroundColor(colors.gray)
term.write("C")
term.setBackgroundColor(colors.red)
term.write("X")
term.setBackgroundColor(colors.blue)
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
x,y=term.getSize()
if p1<5 then
paused=not paused
elseif p1==x and p2==y then
stop=true
elseif p1==x-1 and p2==y then
x,y=term.getSize()
c={}
for i=1,x do
c[i]={}
for j=1, y-1 do
c[i][j]=0
end
end
elseif p1==x-2 and p2==y then
x,y=term.getSize()
c={}
for i=1,x do
c[i]={}
for j=1, y-1 do
c[i][j]=round(math.random())
end
end
elseif p1==x-3 and p2==y then
if not file==nil then
fs.delete(file)
x=fs.open(file,"w")
local nc={}
for k,v in pairs(c) do
table.insert(nc, textutils.serialize(v))
end
x.write(textutils.serialize(nc))
x.close()
end
end
end
paused=true
interval=0.25
sleep(1)
os.startTimer(interval)
draw()
while not stop do
e,p1,p2,p3,p4,p5=os.pullEvent()
if e=="timer" then
os.startTimer(interval)
if not paused then
c=Evolve(c)
end
elseif e=="mouse_click" then
handleclick(p2,p3)
draw()
elseif e=="mouse_drag" then
handleclick(p2,p3)
draw()
elseif e=="monitor_touch" then
handleclick(p2,p3)
draw()
elseif e=="key" then
paused=not paused
draw()
end
end
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)