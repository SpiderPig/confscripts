--require "ex"

abstlx, abstly = 0,0


function mouse_start(winname)
   local tmpfile=os.getenv('HOME').."/tmp/xdostat"

   if xdoproc == nil then
      mouse_shutdown(winname)
--      os.execute("mkfifo "..tmpfile)
--      xdoproc = os.spawn{"xdotool", {'search', '--name', winname, 'behave %@ mouse-click getmouselocation'}}
      print ("executing xdotool search --name '"..winname.."' behave %@ mouse-click getmouselocation > "..tmpfile)
      os.execute("xdotool search --name '"..winname.."' behave %@ mouse-click getmouselocation >> "..tmpfile .." &")
      xdoproc=1

      local f = io.popen("xwininfo -name '"..winname.."' | grep 'Absolute'")
      geometry = f:read("*a")
      f:close()
      local geometry=string.gsub(geometry,"[\n]","")
      print (geometry)
      s,f,abstlx=string.find(geometry,"X%p%s*(-?%d*)")
      s,f,abstly=string.find(geometry,"Y%p%s*(-?%d*)")
--      print ("xdo start  geometry="..abstlx..","..abstly)
   end

end


function mouse_click(winname)
   local tmpfile=os.getenv('HOME').."/tmp/xdostat"

   mouse_start(winname)

   -- pop off the next line from our mouse click queue file
   local file=io.open(tmpfile)
   if file ~= nil then
      click = file:read("*l") do
         if click ~= nil then
            local s,f,mousex=string.find(click,"x%p(%d*)%s")
            local s,f,mousey=string.find(click,"y%p(%d*)%s")
            if mousex ~= nil and mousey ~= nil then
               localx=tonumber(mousex)-abstlx
               localy=tonumber(mousey)-abstly
            end

            local clickq = file:read("*a")
            file:close()
            file = io.open(tmpfile,"w")
            file:write(clickq)
         else
             localx, localy = nil, nil
         end
      end
      file:close()
   else
      print("cant open file")
   end

   return localx,localy
end

function mouse_location(winname)

   mouse_start(winname)

   -- pole for the current position
   local f = io.popen("xdotool getmouselocation")
   mousenow=f:read()
   f:close()
   local s,f,mousenowx=string.find(mousenow,"x%p(%d*)%s")
   local s,f,mousenowy=string.find(mousenow,"y%p(%d*)%s")
   localnowx=tonumber(mousenowx)-abstlx
   localnowy=tonumber(mousenowy)-abstly
   print(localx, localy)
   return localnowx,localnowy
end


function mouse_shutdown(winname)
   local tmpfile=os.getenv('HOME').."/tmp/xdostat"
--   os.execute("fuser -k "..tmpfile)
   os.execute("pkill -f \'xdotool.*"..winname.."\'")
end