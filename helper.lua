print("SCENE-INPUT.LUA", "START")

local openssl		= require ("openssl")
local network 		= require ("network")
local json		= require ("json")
local unpack		= unpack or table.unpack

local cookie		= ''
local inputbox		= {}
local logo		= {}

print("START SCENE: ", scene.name)

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
			print("JSON.ERROR",ans)
			scene:dispatchEvent({name = "inform", text = actions[current_action].failed, obj=loaderText})
			scene:dispatchEvent({name = "error", text = actions[current_action].failed})

		else
			print("JSON CLEAR",ans)
			
			--scene:dispatchEvent({name = "inform", text = actions[current_action].succeed, obj=loaderText})
			--scene:dispatchEvent({name = "inform", text = actions[current_action].succeed, obj=loaderText})
		print("SO WHAT")
		print(actions[current_action].signal)
		scene:dispatchEvent({name = actions[current_action].signal, lastheaders = event.responseHeaders, lastresponse = event.response})
		print("END REQUEST")
		end
	end
	print("FUNC END: REQUEST HANDLER")
end

-------------------------------------CREATE------------------------------- 
function scene:create( event )
	print("START EVENT: ", event.name)
	cookie = event.params.cookie
	local sceneGroup = self.view
logo = display.newImageRect( sceneGroup, "logo.png", 270, 54)
	logo.x = display.contentCenterX-logo.width/2
	logo.y = border
button_send = widget.newButton({
	width = display.contentWidth - border - border - border,
	height = 50,
	label = msg_send_req,
	shape = 'roundedRect',
	cornerRadius = 8,
--	fillColor = { default={1,102/255,102/255}, over={1,0,0} },
	strokeColor = { default={0,0,0}, over={0.7,0.7,0.7} },
	strokeColor = { default={61/255,141/255,253/255}, over={41/255,92/255,162/255} },
	strokeWidth = 3,
	font = "arialuni.ttf",
	align = 'center',
	fontSize = 25,
	labelColor = {default = {0,0,0}},
	labelColor = {default = {61/255,141/255,253/255}, over={41/255,92/255,162/255}},
	onRelease = function() scene:dispatchEvent({name = "button_release"}) end
	})
	button_send.x = border
	button_send.y = display.contentHeight - button_send.height - border
	sceneGroup:insert(button_send)

	print("END EVENT: ", event.name)
end
-------------------------------------CREATE-END------------------------------ 
 
-------------------------------------SHOW------------------------------- 
function scene:show( event )
	print("START EVENT: ", event.name)
	local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
	inputbox = native.newTextBox( border, logo.y+border+logo.height, display.contentWidth - 2 * border, button_send.y - border - logo.y - border - logo.height)
	inputbox:setTextColor(61/255,141/255,253/255)	
	inputbox.isEditable = true
	inputbox.font = native.newFont("Arial", 25)
	inputbox.size = 25
	inputbox.placeholder = msg_your_req
	button_send:setEnabled(true)
    end
	print("END EVENT: ", event.name)
end
-------------------------------------SHOW-END------------------------------ 
 
-------------------------------------HIDE------------------------------- 
function scene:hide( event )
	print("START EVENT: ", event.name)
	print("END EVENT: ", event.name)
end
-------------------------------------HIDE-END------------------------------ 
 
-------------------------------------DESTROY------------------------------- 
function scene:destroy( event )
	print("START EVENT: ", event.name)
    inputbox:removeSelf()
	print("END EVENT: ", event.name)
end
-------------------------------------DESTROY-END------------------------------ 

-------------------------------------ERROR------------------------------- 
function scene:error( event ) 
	print("START EVENT: ", event.name)
	inputbox:removeSelf()
	composer.gotoScene("scene-complete", {effect = "fade", time = 500, params = {message = msg_error..'('..event.text..')'}})
	print("END EVENT: ", event.name)
end
-------------------------------------ERROR-END------------------------------ 
-------------------------------------request-complete------------------------------- 
function scene:request_complete( event ) 
	print("START EVENT: ", event.name)
	inputbox:removeSelf()
	composer.gotoScene("scene-complete", {effect = "fade", time = 500, params = {message = msg_success}})
	print("END EVENT: ", event.name)
end
-------------------------------------request-complete-END------------------------------ 
-------------------------------------button_release------------------------------- 
function scene:button_release( event ) 
	print("START EVENT: ", event.name)
	print("COOKIE",cookie)
	button_send:setEnabled(false)
	params.body = [[equipment=&problem=]].."HOSTNAME: "..system.getInfo("name").."\n"..inputbox.text
	params.headers["Cookie"] = cookie
	params.headers["X-Requested-With"] = "XMLHttpRequest"
	params.headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
	print("DEBUG", urlid)
	network.request( actions['test_request'].url, "POST", requestHandler, params )
	print("END EVENT: ", event.name)
end
-------------------------------------button_release-END------------------------------ 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "error", scene )
scene:addEventListener( "button_release", scene )
scene:addEventListener( "request_complete", scene )

print("END SCENE: ", scene.name)
print("SCENE-INPUT.LUA", "END")
return scene
