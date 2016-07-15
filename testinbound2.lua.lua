------------------------------------------------------------------------------
--[[

     File Name     : testinbound2.lua
     Description   : This File Contains All Conference tag Functionalities 
]]--



uuid = require("uuid") 



function conference(conferencesid,conf_response)
	
  --check if debug is set to true or false if true print the functionname
  if DebugStatus == "true" then
   debuglogtime=os.date("%Y-%m-%d %H:%M:%S");
   local funcname=debug.getinfo(1, "n").name;
   local info = debug.getinfo(1,'S');
   filename = info.source;
   debug_data="GETINFO 29 FileName:"..filename..", functioname:"..funcname..", callsid:"..CallSid.."\n"
   freeswitch.consoleLog("debug",debug_data)
 end

   mute_status,beep_status,max_participants,wait_url,wait_method,hangup_button,conference_callback,conference_callbackmethod,digit_match,stay_alone,conference_recordstatus,conference_recordcallurl,conference_recordformat,conf_fromcountrycode,conf_tocountrycode=InboundTags('conference',conf_response)
   beep_status=beep_status:lower()
   mute_status=mute_status:lower()
   stay_alone=stay_alone:lower()
 
  if wait_url ~= "NOURL" then
    waiturlresponse,waiturlresponsecode=SendRequest(wait_url,wait_method,'')
    if waiturlresponsecode == 200 then
      waitresponse=string.gsub(waiturlresponse, "\n", "")
      for conf_response in string.gmatch(waitresponse, "<.-</") do
        if string.find(conf_response,"<Play") or string.find(conf_response,"<play") then
          
       Play(conf_response)
        elseif string.find(conf_response,"<Say") or string.find(conf_response,"<say") then
          Say(conf_response)
        end                                                                                      --END OF IF ELSE
      end                                                                                        --END OF FOR LOOP
    end                                                                                          --END OF IF ELSE
  end                               
  
   conf_starttime=os.date("%Y-%m-%d %H:%M:%S");
   conference_starttime =os.time();
   conference_status="In-progress";
 
  --Check if mute status is true or not if mute conference default is in mute status
   if mute_status == "true" then mute_status = "mute" else mute_status = "" end

  --check if beep status is true or not
    if  beep_status == "true"  then
      session:streamFile('/usr/share/freeswitch/scripts/lua/beep.wav') 
    end


    if stay_alone == "true"  then stay="" else stay="mintwo" end

  --check recording parameters
      if conference_recordstatus == "true" or conference_recordstatus == "True" then
    conferernce_recordfile=os.date("%Y%m%d%H%M%S").."_"..CalledNumber.."."..conference_recordformat;
    conference_recordurl="/recordings/"..CompanyId.."/"..conferernce_recordfile
    IsActive="Yes"
    conference_recordstarttime=os.date("%Y-%m-%d %H:%M:%S");

   --set dual channel for recording and start recording in background
    session:setVariable("RECORD_STEREO","true")
    session:execute("record_session",conference_recordurl)
    end 
 
  
    --If Stay Alone is true then min two particpants should be in Conference room

  --if any digit matching is recieved set accept only the digits during the conference call
  if digit_match == "NODIGITS" then
  else
    Bind_digit="my_digits,"..digit_match..",exec:execute_extension,LOG_DIGITS XML default,both"
    session:execute("bind_digit_action",Bind_digit)
  end

  --Set Conference Room Id
  conference_room_id = CallSid.."@default".."+flags{"..mute_status.."|"..stay.."}"

  --Contiue Call after Conference


  session:setVariable("hangup_after_conference","false")
  session:execute("set","hangup_after_conference=false")

  YearMonthDayConference =(os.date("%Y%m%d"))
  
  --conference_name="PLIVO"
  conference_starttime=os.time();
  conference_logs = [[INSERT INTO conference_logs (account_sid,year_month_day,conference_name,conference_sid,beep_status,bridge_number,direction,from_country_code,max_limit,record_status,record_type,record_url,start_time,status,to_country_code) values(]]..AccountSid..[[,']]..YearMonthDayConference..[[',']]..CallSid..[[',]]..CallSid..[[,']]..beep_status..[[',']]..CalledNumber..[[',']]..Direction..[[',]]..conf_fromcountrycode..[[,]]..max_participants..[[,']]..conference_recordstatus..[[',']]..conference_recordformat..[[',']]..conference_recordcallurl..[[',']]..conf_starttime..[[',']]..conference_status..[[',]]..conf_tocountrycode..[[)]]
  _CQL_INSERT(conference_logs)
conf_endtime=""
 conference_parameters="ConferenceSid="..conferencesid.."&ConferenceStartTime="..conf_starttime.."&ConferenceStatus=in-progress".."&Direction="..Direction.."&ConferenceEndTime="..conf_endtime

  if conference_callback == "NOURL" then else SendRequest(conference_callback,conference_callbackmethod,conference_parameters) end
  
  --Adding to a conference room
  session:execute("conference",conference_room_id)
  hangupparticipants="conference "..CallSid.." hup all"
  api = freeswitch.API()
  s=api:executeString(hangupparticipants)
   last_digits=session:getVariable('last_matching_digits') or ''
  conf_endtime=os.date("%Y-%m-%d %H:%M:%S");
  conference_parameters="ConferenceSid="..conferencesid.."&ConferenceStartTime="..conf_starttime.."&ConferenceStatus=completed".."&Direction="..Direction.."&ConferenceEndTime="..conf_endtime.."&DigitMatch="..last_digits
  if conference_callback == "NOURL" then else SendRequest(conference_callback,conference_callbackmethod,conference_parameters) end

return Confer
 
end
