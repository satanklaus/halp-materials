local json		= require ("json")



function string.urlEncode ( str ) if ( str ) then
        str = string.gsub( str, "\n", "\r\n" )
        str = string.gsub( str, "([^%w ])",
            function( c )
                return string.format( "%%%02X", string.byte(c) )
            end
        )
        str = string.gsub( str, " ", "+" )
    end
    return str
end

function requestHandler (event)
	print("FUNC START: REQUEST HANDLER")
	current_action = ""
	for action in pairs(actions) do 
		if actions[action].url == event.url then current_action = action end
	end
	print("TRY TO SEND", current_action)
	if (event.isError) then
		print("EVENT ERROR")
		scene:dispatchEvent({name = "error", text = event.response, action = actions[current_action].failed})

	else 
		print("EVENT CLEAR")
		ans= json.decode(event.response)
		if ans.error then 
			print("J.SON ERROR",ans)
			for j,k in pairs(ans) do print(j,k) end
			print("JSON ERROR-END",ans)
			scene:dispatchEvent({name = "inform", text = actions[current_action].failed, obj=loaderText})
			scene:dispatchEvent({name = "error", text = actions[current_action].failed})

		else
			print("JSON CLEAR",ans)
		scene:dispatchEvent({name = "inform", text = actions[current_action].succeed, obj=loaderText})
		print("SO WHAT")
		print(actions[current_action].signal)
		scene:dispatchEvent({name = actions[current_action].signal, lastheaders = event.responseHeaders, lastresponse = event.response})
		print("END REQUEST")
		end
	end
	print("FUNC END: REQUEST HANDLER")
end

	function dots(timer)
		postfix = ""
		for i = 1, (timer.count)%4 do postfix = postfix .."." end 
		loaderText:setText(loaderText.basetext..postfix)
	end

