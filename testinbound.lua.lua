--[[
          File Name    : testInbound.lua
          Description  : This file is executed when server recieves an Incoming call (starts at Line session:answer())

]]--
--do return end 
require "M360/V2/lua/Modules/YtelLogs"
require "M360/V2/lua/Modules/YtelInboundTags"
require "M360/V2/lua/Modules/InboundTags"
require "M360/V2/lua/Modules/YtelBilling"
require "M360/V2/lua/YtelConference"
require "M360/lua/Config/Config"


-------------------------------------------------------------------------
---send http request and get response using Socket.http
function  ytelSendRequest(HttpRequestUrl,HttpMethod,RequestParameters)

if DebugStatus == "true" then
   debuglogtime=os.date("%Y-%m-%d %H:%M:%S");
   local funcname=debug.getinfo(1, "n").name;
   local info = debug.getinfo(1,'S');
   filename = info.source;
   debug_data= "GETINFO 18 FileName:"..filename..", functioname:"..funcname..", callsid:"..CallSid.."\n"
   freeswitch.consoleLog("debug",debug_data)
 end
  --Convert Method to Lower case and compare if Method is GET or POST
  HttpMethod=HttpMethod:lower()
  if RequestParameters == nil  then RequestParameters = "" end

  --Check If URL is Empty or Nill .If empty Return response as INVALID RESPONSE and Response code is 404
  if HttpRequestUrl == nil or HttpRequestUrl == "" or HttpRequestUrl == "NOURL" or HttpRequestUrl == " " or HttpRequestUrl == "NULL" then
    return "INVALID RESPONSE","404"
  else
    HttpRequestUrl=string.gsub(HttpRequestUrl,"&amp;","&")
    RequestParameters=string.gsub(RequestParameters,"&amp;","&")

    responseheaders={}

    --Check if Method is GET
    if HttpMethod == "get" then



      --Check if Request Url Contains any Query String or not
      if string.match(HttpRequestUrl,"?") then Delimier="&" else Delimier="?" end
      --RequestParameters=string.gsub(RequestParameters, "%s+", "")
      UrlParameters={}

if getPlayFile == "" then
 elseif string.find(getPlayFile, ".mp3$") or string.find(getPlayFile, ".mp3$") then 
--  soxresponse,audioUrl=AudioType(getPlayFile)
--       if soxresponse == 'true' then
    PlayTime=os.date("%Y-%m-%d %H:%M:%S");
	if DebugStatus == "true" then
   		debug_data="GETINFO 20-2  AFTer playtime , callsid:"..CallSid.."\n"
   		freeswitch.consoleLog("debug",debug_data)
 	end
    Digits1=tonumber(Digits1)
	if DebugStatus == "true" then
   		debug_data="GETINFO 20-3  AFTer tonumber Digits , callsid:"..CallSid.."\n"
   		freeswitch.consoleLog("debug",debug_data)
 	end
  			  
      --Play Audio File
      PlayFile(http://s3.amazonaws.com/plivocloud/Trumpet.mp3)

      --If Instuction is set to Play audio
    elseif string.find(getResponse,"<Play") or string.find(getResponse,"<play") then

      --Get Attribute values set for Play Tag
      YtelPlay(getResponse)


        --Send Http Request and get response
        RedirectResponse,RedirectResponseCode= ytelSendRequest(Redirect,RedirectMethod,RedirectParameters)
        --Convert http responsecode to number (string to number) if success the execute the instructions
        RedirectResponseCode=tonumber(RedirectResponseCode)
        if RedirectResponseCode  == 200 then
          RedirectResponse=string.gsub(RedirectResponse, "\n", "");
          CurlExecution(RedirectResponse)
        end
      end       --END OF ACTION TAG

-----------------------Inbound Call Starts From Here --------------------------------------------------
---------- GET ALL session VARIABLES
session:answer();
session:setVariable("gather_increment_value","0")                            
--From number
  CallerNumber=string.gsub(CallerNumber,"^+1","")
  CalledNumber=session:getVariable("destination_number");                  --To Number
  Direction=session:getVariable("direction");
  CreateTime=session:getVariable("created_time");                          --Get Call Create Time in Epoch Time
  CallInitatedTime=(string.sub(CreateTime,1,10));
  CallInitatedTime1=(string.sub(CreateTime,1,10));
   NewCreateTime=(os.date("%Y%m%d",CallInitatedTime))
  CallInitatedTime=(os.date("%Y-%m-%d %H:%M:%S",CallInitatedTime));        --Convert CallIntiateTime to yyyy-mm-dd hh:mm:ss
  CallTime=string.gsub(CallInitatedTime," ","-")
  AnsweredTime=session:getVariable("answered_time")                        --Get Call Answered Time in Epoch Time
  Starttime=(string.sub(AnsweredTime,1,10));
  StartTime=(os.date("%Y-%m-%d %H:%M:%S",Starttime));  		    


        session:hangup()

function on_hangup(status)
--[[if DebugStatus == "true" then
   debuglogtime=os.date("%Y-%m-%d %H:%M:%S");
   local funcname=debug.getinfo(1, "n").name;
   local info = debug.getinfo(1,'S');
   filename = info.source;
   debug_data=" FileName:"..filename..", functioname:"..funcname..", callsid:"..CallSid..", Time:"..debuglogtime
 end
--]]
  --Update Record Duration During call hangup

  if RecordTranscribe ~= nil then RecordTranscribe=RecordTranscribe   else     RecordTranscribe='false'  end
  HangupStatus="completed"


