print("SCENE-LOADING.LUA", "START")

local composer 		= require( "composer" )
local widget 		= require ("widget")
local openssl		= require ("plugin.openssl")
local network 		= require ("network")
local unpack		= unpack or table.unpack
local base64		= require("base64")
local data		= require("data")
local funcs		= require("functions")
local json		= require("json")
local cookie		= {}
config_loaded		= false
restarted		= false
loaderText 	= {}
scene 		= composer.newScene()

scene.name = composer.getSceneName('current')
print("START SCENE: ", scene.name)
 
display.setDefault( "anchorX", 0 )
display.setDefault( "anchorY", 0 )
display.setDefault( "background", 1,1,1)
border = 10


-------------------------------------CREATE------------------------------- 
function scene:create( event )
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	local sceneGroup = self.view
local logo = display.newImageRect( sceneGroup, "logo.png", 270, 54)
	logo.x = display.contentCenterX-logo.width/2
	logo.y = border
	spinner = widget.newSpinner({ width = 50, height = 50, })
	spinner.x = display.contentCenterX - spinner.width/2
	spinner.y = display.contentCenterY - spinner.height/2
	sceneGroup:insert(spinner)
	spinner:start()

loaderText = display.newEmbossedText({
	parent = sceneGroup,
	text = "",
	width = display.actualContentWidth,
	x = 0,
	y = spinner.y+spinner.height + border,
	font = native.systemFontBold,
	font = "arialuni.ttf",
	align = 'center',
	fontSize = 20,
	})
	loaderText.basetext = msg_loading
	loaderText:setFillColor( 61/255, 141/255, 253/255 )
	local color = { }
	loaderText:setEmbossColor( color )

	timer_dots = timer.performWithDelay(300, dots, -1) 
		scene:dispatchEvent({name = "inform", text = msg_config})
		scene:dispatchEvent({name = "load_config"})


----------------------------------------------------------------------------------------------------------------

--	config,err = io.open(".\\halpcfg.lua")
--	if not config then
--		scene:dispatchEvent({name = "error", text = msg_config_err.." : "..err})
--	else
--	loadstring(config:read("*a"))()
--	print("DEBUG7", actions['test_request'].url)
--	actions['test_request'].url = actions['test_request'].url..urlid 
--	print("DEBUG7", actions['test_request'].url)
--	end
----------------------------------------------------------------------------------------------------------------

	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------CREATE-END------------------------------ 
 
-------------------------------------SHOW------------------------------- 
function scene:show( event )
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
 	local phase = event.phase
	if ( phase == "did" ) then
	print("==============================DID")
	if restarted then
		timer_dots = timer.performWithDelay(300, dots, -1) 
		scene:dispatchEvent({name = "inform", text = "AMO RES", obj=loaderText})
		scene:dispatchEvent({name = "get_key"})
	end

	else print("====================== NOT DID")
	end
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------SHOW-END------------------------------]]
 
-------------------------------------HIDE------------------------------- 
function scene:hide( event )
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
	    timer.cancel(timer_dots)
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------HIDE-END------------------------------ 
 
-------------------------------------DESTROY------------------------------- 
function scene:destroy( event )
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------DESTROY-END------------------------------ 
-------------------------------------INFORM------------------------------- 
function scene:inform( event )
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	if (event.obj) then event.obj.basetext = event.text end
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------INFORM-END------------------------------ 
-------------------------------------GET_KEY------------------------------- 
function scene:get_key( event )
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	scene:dispatchEvent({name = "inform", text = actions['key'].desc, obj=loaderText})
	network.request( actions['key'].url, "POST", requestHandler)
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------GET_KEY-END------------------------------ 
-------------------------------------ERROR------------------------------- 
function scene:error( event ) 
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	composer.gotoScene("scene-complete", {effect = "fade", time = 500, params = {message = msg_error..'('..event.text..')'}})
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------ERROR-END------------------------------ 
-------------------------------------login------------------------------- 
function scene:login( event ) 
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	print(username, password)
	cookie = event.lastheaders['Set-Cookie']:match('[^%s;]+')
	ans= json.decode(event.lastresponse)
	cert = openssl.pkey_read(ans.key)
	crypt_password = string.urlEncode(base64.encode(cert:encrypt(password)))
	params = {headers = {}}
	username_url = string.urlEncode(username)
	params.body = "name="..username_url.."&pass="..crypt_password.."&changePass=false"
	params.headers["Cookie"] = cookie
	params.headers["X-Requested-With"] = "XMLHttpRequest"
	params.headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
	scene:dispatchEvent({name = "inform", text = actions['login'].desc, obj=loaderText})
	network.request( actions['login'].url, "POST", requestHandler, params )
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------login-END------------------------------ 
-------------------------------------filter-build------------------------------- 
function scene:filter_build( event ) 
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	params = {headers = {}}
	params.body = "{}"
	params.headers["Cookie"] = cookie
	params.headers["X-Requested-With"] = "XMLHttpRequest"
	params.headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
	scene:dispatchEvent({name = "inform", text = actions['filter_build'].desc, obj=loaderText})
	network.request( actions['filter_build'].url, "POST", requestHandler, params )
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)

end
-------------------------------------filter_build-END------------------------------ 
-------------------------------------filter_set------------------------------- 
function scene:filter_set( event ) 
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	params = {headers = {}}
	params.body = "byDiv=C58434999-cbf3-11e5-a7aa-002590839a1d&bySrv=S5025648d-6de4-11e6-95f3-002590839a1d&byText=&byFrom=2000-09-01&byTo=2000-09-01&onlyMy=0"
	params.headers["Cookie"] = cookie
	params.headers["X-Requested-With"] = "XMLHttpRequest"
	params.headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
	scene:dispatchEvent({name = "inform", text = actions['filter_set'].desc, obj=loaderText})
	network.request( actions['filter_set'].url, "POST", requestHandler, params )
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------filter_set-END------------------------------ 
-------------------------------------ready------------------------------- 
function scene:ready( event ) 
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	composer.gotoScene("scene-input",{effect = "fade", time = 500, params = {cookie = cookie}})
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------ready-END------------------------------ 
-------------------------------------load_config------------------------------- 
function scene:load_config( event ) 
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
	scene:dispatchEvent({name = "inform", text = msg_loading, obj=loaderText})
	config,err = io.open(".\\halpcfg.lua")
	if not config then
		scene:dispatchEvent({name = "error", text = msg_config_err.." : "..err})
	else
	loadstring(config:read("*a"))()
	actions['test_request'].url = actions['test_request'].url..urlid 
	config_loaded = true
	scene:dispatchEvent({name = "get_key"})
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
	end
end
-------------------------------------load_config-END------------------------------ 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "inform", scene )
scene:addEventListener( "get_key", scene )
scene:addEventListener( "error", scene )
scene:addEventListener( "login", scene )
scene:addEventListener( "filter_set", scene )
scene:addEventListener( "filter_build", scene )
scene:addEventListener( "ready", scene )
scene:addEventListener( "load_config", scene )
print("END SCENE: ", scene.name)
print("SCENE-LOADING.LUA", "END")
return scene
