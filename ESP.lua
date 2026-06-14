local W,R,P,C=cloneref(game:GetService("Workspace")),cloneref(game:GetService("RunService")),cloneref(game:GetService("Players")),game:GetService("CoreGui")
local lp=P.LocalPlayer
local cam=W.CurrentCamera
local tickv=tick()
local rot=-45

local cfg={
E=true,TC=true,MD=200,FS=11,
FO={D=true},
O={T=true,TR=Color3.fromRGB(0,255,0),F=true,FR=Color3.fromRGB(0,255,0),H=true,HR=Color3.fromRGB(255,0,0)},
D={
C={E=true,Th=true,FC=Color3.fromRGB(119,120,255),FT=100,OC=Color3.fromRGB(119,120,255),OT=100,VC=true},
N={E=true,C=Color3.fromRGB(255,255,255)},
F={E=false},
Di={E=true,P="Text",C=Color3.fromRGB(255,255,255)},
We={E=false},
Hb={E=true,HT=true,C=Color3.fromRGB(119,120,255),W=2.5,G=true,G1=Color3.fromRGB(200,0,0),G2=Color3.fromRGB(60,60,125),G3=Color3.fromRGB(119,120,255)},
B={A=true,RS=300,GF=true,G1=Color3.fromRGB(119,120,255),G2=Color3.fromRGB(0,0,0),Fi={E=true,T=0.75,C=Color3.fromRGB(0,0,0)},Fu={E=true,C=Color3.fromRGB(255,255,255)},Co={E=true,C=Color3.fromRGB(255,255,255)}}
}
}

local f={}
function f:C(c,p)local i=typeof(c)=="string"and Instance.new(c)or c for k,v in pairs(p)do i[k]=v end return i end
function f:F(e,d)local t=math.max(0.1,1-(d/cfg.MD))if e:IsA("TextLabel")then e.TextTransparency=1-t elseif e:IsA("UIStroke")then e.Transparency=1-t elseif e:IsA("Frame")then e.BackgroundTransparency=1-t elseif e:IsA("Highlight")then e.FillTransparency=1-t e.OutlineTransparency=1-t end end

local sg=f:C("ScreenGui",{Parent=C,Name="E"})
local dc=function(p)local e=sg:FindFirstChild(p.Name)if e then e:Destroy()end end

local esp=function(p)
coroutine.wrap(dc)(p)
local n=f:C("TextLabel",{Parent=sg,Position=UDim2.new(0.5,0,0,-11),Size=UDim2.new(0,100,0,20),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.Code,TextSize=cfg.FS,TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0),RichText=true})
local d=f:C("TextLabel",{Parent=sg,Position=UDim2.new(0.5,0,0,11),Size=UDim2.new(0,100,0,20),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.Code,TextSize=cfg.FS,TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0),RichText=true})
local w=f:C("TextLabel",{Parent=sg,Position=UDim2.new(0.5,0,0,31),Size=UDim2.new(0,100,0,20),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.Code,TextSize=cfg.FS,TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0),RichText=true})
local b=f:C("Frame",{Parent=sg,BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.75,BorderSizePixel=0})
local g1=f:C("UIGradient",{Parent=b,Enabled=cfg.D.B.GF,Color=ColorSequence.new{ColorSequenceKeypoint.new(0,cfg.D.B.G1),ColorSequenceKeypoint.new(1,cfg.D.B.G2)}})
local o=f:C("UIStroke",{Parent=b,Enabled=false,Transparency=0,Color=Color3.fromRGB(255,255,255),LineJoinMode=Enum.LineJoinMode.Miter})
local g2=f:C("UIGradient",{Parent=o,Enabled=false,Color=ColorSequence.new{ColorSequenceKeypoint.new(0,cfg.D.B.G1),ColorSequenceKeypoint.new(1,cfg.D.B.G2)}})
local hb=f:C("Frame",{Parent=sg,BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0})
local bh=f:C("Frame",{Parent=sg,ZIndex=-1,BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0})
local hg=f:C("UIGradient",{Parent=hb,Enabled=cfg.D.Hb.G,Rotation=-90,Color=ColorSequence.new{ColorSequenceKeypoint.new(0,cfg.D.Hb.G1),ColorSequenceKeypoint.new(0.5,cfg.D.Hb.G2),ColorSequenceKeypoint.new(1,cfg.D.Hb.G3)}})
local ht=f:C("TextLabel",{Parent=sg,Position=UDim2.new(0.5,0,0,31),Size=UDim2.new(0,100,0,20),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.Code,TextSize=cfg.FS,TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0)})
local ch=f:C("Highlight",{Parent=sg,FillTransparency=1,OutlineTransparency=0,OutlineColor=Color3.fromRGB(119,120,255),DepthMode="AlwaysOnTop"})
local lt=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local ls=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local rt=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local rs=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local bs=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local bd=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local brs=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local brd=f:C("Frame",{Parent=sg,BackgroundColor3=cfg.D.B.Co.C,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0)})
local f1=f:C("TextLabel",{Parent=sg,Position=UDim2.new(1,0,0,0),Size=UDim2.new(0,100,0,20),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.Code,TextSize=cfg.FS,TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0)})
local f2=f:C("TextLabel",{Parent=sg,Position=UDim2.new(1,0,0,0),Size=UDim2.new(0,100,0,20),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.Code,TextSize=cfg.FS,TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0)})

local function hide()
b.Visible=false n.Visible=false d.Visible=false w.Visible=false
hb.Visible=false bh.Visible=false ht.Visible=false
lt.Visible=false ls.Visible=false bs.Visible=false bd.Visible=false
rt.Visible=false rs.Visible=false brs.Visible=false brd.Visible=false
f1.Visible=false f2.Visible=false ch.Enabled=false
end

local con
con=R.RenderStepped:Connect(function()
if not p or not p.Parent then hide() sg:Destroy() con:Disconnect() return end
local char=p.Character
if not char then hide() return end
local hrp=char:FindFirstChild("HumanoidRootPart")
local hum=char:FindFirstChild("Humanoid")
if not hrp or not hum then hide() return end

local pos,on=cam:WorldToScreenPoint(hrp.Position)
local dist=(cam.CFrame.Position-hrp.Position).Magnitude/3.5714285714
if not on or dist>cfg.MD then hide() return end

local sz=hrp.Size.Y
local sf=(sz*cam.ViewportSize.Y)/(pos.Z*2)
local ww,hh=3*sf,4.5*sf

if cfg.FO.D then
local els={b,o,n,d,w,hb,bh,ht,lt,ls,bs,bd,rt,rs,brs,brd,ch,f1,f2}
for _,e in ipairs(els)do f:F(e,dist)end
end

if cfg.TC and p~=lp and((lp.Team~=p.Team and p.Team)or(not lp.Team and not p.Team))then
ch.Adornee=char ch.Enabled=cfg.D.C.E
ch.FillColor=cfg.D.C.FC ch.OutlineColor=cfg.D.C.OC
if cfg.D.C.Th then
local be=math.atan(math.sin(tick()*2))*2/math.pi
ch.FillTransparency=cfg.D.C.FT*be*0.01
ch.OutlineTransparency=cfg.D.C.OT*be*0.01
end
ch.DepthMode=cfg.D.C.VC and"Occluded"or"AlwaysOnTop"

lt.Visible=cfg.D.B.Co.E lt.Position=UDim2.new(0,pos.X-ww/2,0,pos.Y-hh/2)lt.Size=UDim2.new(0,ww/5,0,1)
ls.Visible=cfg.D.B.Co.E ls.Position=UDim2.new(0,pos.X-ww/2,0,pos.Y-hh/2)ls.Size=UDim2.new(0,1,0,hh/5)
bs.Visible=cfg.D.B.Co.E bs.Position=UDim2.new(0,pos.X-ww/2,0,pos.Y+hh/2)bs.Size=UDim2.new(0,1,0,hh/5)bs.AnchorPoint=Vector2.new(0,5)
bd.Visible=cfg.D.B.Co.E bd.Position=UDim2.new(0,pos.X-ww/2,0,pos.Y+hh/2)bd.Size=UDim2.new(0,ww/5,0,1)bd.AnchorPoint=Vector2.new(0,1)
rt.Visible=cfg.D.B.Co.E rt.Position=UDim2.new(0,pos.X+ww/2,0,pos.Y-hh/2)rt.Size=UDim2.new(0,ww/5,0,1)rt.AnchorPoint=Vector2.new(1,0)
rs.Visible=cfg.D.B.Co.E rs.Position=UDim2.new(0,pos.X+ww/2-1,0,pos.Y-hh/2)rs.Size=UDim2.new(0,1,0,hh/5)rs.AnchorPoint=Vector2.new(0,0)
brs.Visible=cfg.D.B.Co.E brs.Position=UDim2.new(0,pos.X+ww/2,0,pos.Y+hh/2)brs.Size=UDim2.new(0,1,0,hh/5)brs.AnchorPoint=Vector2.new(1,1)
brd.Visible=cfg.D.B.Co.E brd.Position=UDim2.new(0,pos.X+ww/2,0,pos.Y+hh/2)brd.Size=UDim2.new(0,ww/5,0,1)brd.AnchorPoint=Vector2.new(1,1)

b.Position=UDim2.new(0,pos.X-ww/2,0,pos.Y-hh/2)
b.Size=UDim2.new(0,ww,0,hh)b.Visible=cfg.D.B.Fu.E
if cfg.D.B.Fi.E then
b.BackgroundColor3=Color3.fromRGB(255,255,255)
b.BackgroundTransparency=cfg.D.B.GF and cfg.D.B.Fi.T or 1
b.BorderSizePixel=1
else b.BackgroundTransparency=1 end

rot=rot+(tick()-tickv)*cfg.D.B.RS*math.cos(math.pi/4*tick()-math.pi/2)
g1.Rotation=cfg.D.B.A and rot or-45
g2.Rotation=cfg.D.B.A and rot or-45
tickv=tick()

local hl=hum.Health/hum.MaxHealth
hb.Visible=cfg.D.Hb.E
hb.Position=UDim2.new(0,pos.X-ww/2-6,0,pos.Y-hh/2+hh*(1-hl))
hb.Size=UDim2.new(0,cfg.D.Hb.W,0,hh*hl)
bh.Visible=cfg.D.Hb.E
bh.Position=UDim2.new(0,pos.X-ww/2-6,0,pos.Y-hh/2)
bh.Size=UDim2.new(0,cfg.D.Hb.W,0,hh)

if cfg.D.Hb.HT then
local hp=math.floor(hl*100)
ht.Position=UDim2.new(0,pos.X-ww/2-6,0,pos.Y-hh/2+hh*(1-hp/100)+3)
ht.Text=tostring(hp)
ht.Visible=hum.Health<hum.MaxHealth
if cfg.D.Hb.G then
local c=hl>=0.75 and Color3.fromRGB(0,255,0)or hl>=0.5 and Color3.fromRGB(255,255,0)or hl>=0.25 and Color3.fromRGB(255,170,0)or Color3.fromRGB(255,0,0)
ht.TextColor3=c
else ht.TextColor3=cfg.D.Hb.C end
end

n.Visible=cfg.D.N.E
if cfg.O.F and lp:IsFriendsWith(p.UserId)then
n.Text=string.format('(<font color="rgb(%d,%d,%d)">F</font>) %s',cfg.O.FR.R*255,cfg.O.FR.G*255,cfg.O.FR.B*255,p.Name)
else n.Text=string.format('(<font color="rgb(%d,%d,%d)">E</font>) %s',255,0,0,p.Name)end
n.Position=UDim2.new(0,pos.X,0,pos.Y-hh/2-9)

if cfg.D.Di.E then
if cfg.D.Di.P=="Bottom"then
w.Position=UDim2.new(0,pos.X,0,pos.Y+hh/2+18)
d.Position=UDim2.new(0,pos.X,0,pos.Y+hh/2+7)
d.Text=string.format("%d meters",math.floor(dist))d.Visible=true
else
w.Position=UDim2.new(0,pos.X,0,pos.Y+hh/2+8)
d.Visible=false
if cfg.O.F and lp:IsFriendsWith(p.UserId)then
n.Text=string.format('(<font color="rgb(%d,%d,%d)">F</font>) %s [%d]',cfg.O.FR.R*255,cfg.O.FR.G*255,cfg.O.FR.B*255,p.Name,math.floor(dist))
else n.Text=string.format('(<font color="rgb(%d,%d,%d)">E</font>) %s [%d]',255,0,0,p.Name,math.floor(dist))end
n.Visible=cfg.D.N.E
end
end
w.Text="none"w.Visible=cfg.D.We.E
else hide()end
end)
end

for _,v in pairs(P:GetPlayers())do if v~=lp then coroutine.wrap(esp)(v)end end
P.PlayerAdded:Connect(function(v)coroutine.wrap(esp)(v)end)
