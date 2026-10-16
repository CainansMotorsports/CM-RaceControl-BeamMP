-- Cainan's Motorsports Race Control | independent server-side prototype v0.1
-- No copied third-party source. No automatic checkpoint scoring in this version.
local TAG = '[CM Race Control] '
local cfg = { adminNames = { 'cainan' }, maxDrivers = 25 }
local state = { flag='OFF', running=false, raceName='Crowleys Ridge Raceway', laps=20, registered={}, approved={}, order={} }
local function say(id,msg) if MP and MP.SendChatMessage then MP.SendChatMessage(id,TAG..msg) end end
local function admin(name)
  for _,n in ipairs(cfg.adminNames) do if n == name and n ~= 'CHANGE_TO_YOUR_EXACT_BEAMMP_NAME' then return true end end
  return false
end
local function sync(id)
  if MP and MP.TriggerClientEvent and Util and Util.JsonEncode then
    local snapshot={ flag=state.flag, running=state.running, raceName=state.raceName, laps=state.laps, registered=state.registered, approved=state.approved, order=state.order, scoring='NOT_CONNECTED' }
    local ok,payload=pcall(Util.JsonEncode,snapshot)
    if ok then MP.TriggerClientEvent(id,'CMRC_State',payload) end
  end
end
local function broadcast(msg) say(-1,msg); sync(-1) end
local function contains(t,value) for _,v in ipairs(t) do if v==value then return true end end return false end
local function remove(t,value) for i=#t,1,-1 do if t[i]==value then table.remove(t,i) end end end
function CMRC_onChatMessage(senderID,name,message)
  if type(message)~='string' then return end
  local cmd,args=message:match('^/(cm%S+)%s*(.-)%s*$')
  if not cmd then return end
  if cmd=='cmhelp' then
    say(senderID,'/cmstatus /cmregister /cmhelp | Admin: /cmapprove NAME /cmremove NAME /cmflag GREEN|YELLOW|RED|OFF /cmstart /cmstop /cmsetlaps N')
  elseif cmd=='cmstatus' then
    say(senderID,string.format('%s | Flag %s | %s | %d approved | scoring not connected',state.raceName,state.flag,state.running and 'RUNNING' or 'IDLE',#state.approved))
    sync(senderID)
  elseif cmd=='cmregister' then
    if contains(state.registered,name) or contains(state.approved,name) then say(senderID,'Already registered or approved.')
    elseif #state.registered+#state.approved>=cfg.maxDrivers then say(senderID,'Registration full.')
    else table.insert(state.registered,name); say(senderID,'Registration requested; awaiting approval.'); sync(-1) end
  elseif not admin(name) then
    say(senderID,'Race Director permission required. Configure adminNames in main.lua.'); return 1
  elseif cmd=='cmapprove' then
    if not contains(state.registered,args) then say(senderID,'No pending registration for '..args)
    else remove(state.registered,args); if not contains(state.approved,args) then table.insert(state.approved,args) end; broadcast(args..' approved.') end
  elseif cmd=='cmremove' then
    remove(state.registered,args); remove(state.approved,args); remove(state.order,args); broadcast(args..' removed.')
  elseif cmd=='cmflag' then
    args=args:upper()
    if args~='GREEN' and args~='YELLOW' and args~='RED' and args~='OFF' then say(senderID,'Use GREEN, YELLOW, RED or OFF.')
    else state.flag=args; broadcast('Flag: '..args..' | scoring prototype only') end
  elseif cmd=='cmstart' then
    if #state.approved==0 then say(senderID,'Approve at least one driver first.')
    else state.running=true; state.flag='GREEN'; state.order={}; for _,n in ipairs(state.approved) do table.insert(state.order,n) end; broadcast('Race started (manual state only; automatic scoring not connected).') end
  elseif cmd=='cmstop' then state.running=false; state.flag='OFF'; broadcast('Race stopped.')
  elseif cmd=='cmsetlaps' then
    local n=tonumber(args)
    if not n or n%1~=0 or n<1 or n>1000 then say(senderID,'Lap count must be 1-1000.')
    else state.laps=n; broadcast('Race laps set to '..n) end
  else say(senderID,'Unknown CM command. Type /cmhelp.') end
  return 1
end
function CMRC_onPlayerJoin(playerID) sync(playerID) end
MP.RegisterEvent('onChatMessage','CMRC_onChatMessage')
MP.RegisterEvent('onPlayerJoin','CMRC_onPlayerJoin')
print(TAG..'v0.1 loaded; automatic lap timing NOT connected; configure adminNames before use.')
