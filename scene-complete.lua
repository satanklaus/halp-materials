print("SCENE-COMPLETE.LUA", "START")

local composer 		= require( "composer" )
local widget 		= require ("widget")
local openssl		= require ("plugin.openssl")
local network 		= require ("network")
local json		= require ("json")
local unpack		= unpack or table.unpack

local cookie		= {}
local logo		= {}
local scene 		= composer.newScene()

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
logo = display.newImageRect( sceneGroup, "logo.png", 270, 54)
	logo.x = display.contentCenterX-logo.width/2
	logo.y = border

finaltext = display.newEmbossedText({
	parent = sceneGroup,
	text = event.params.message,
	width = display.actualContentWidth,
	x = 0,
	y = logo.y+logo.height + border,
	font = native.systemFontBold,
	font = "arialuni.ttf",
	align = 'center',
	fontSize = 30,
	})
	finaltext:setFillColor( 61/255, 141/255, 253/255 )
	local color = { }
	finaltext:setEmbossColor( color )

button_restart = widget.newButton({
	width = display.contentWidth - border - border - border,
	height = 50,
	label = msg_restart,
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
	onRelease = function() scene:dispatchEvent({name = "restart_app"}) end
})
	button_restart.x = border
	button_restart.y = finaltext.y +finaltext.height + border
	sceneGroup:insert(button_restart)
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------CREATE-END------------------------------ 
 
-------------------------------------SHOW------------------------------- 
function scene:show( event )
	print("["..composer.getSceneName('current').."]" ,"START EVENT: ", event.name)
--	finaltext.text = event.params.message
	button_restart.x = border
	button_restart.y = finaltext.y +finaltext.height + border
--	print(event.params.message)
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
    end
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------SHOW-END------------------------------ 
 
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
-------------------------------------restart_app------------------------------- 
function scene:restart_app( event ) 
	print("!RESTART EVENT: ", event.name)
	print("--------------------------------------------------------restart_app EVENT") 
--	composer.removeScene("scene-loading", true)
	restarted = true
	composer.gotoScene("scene-loading", {effect = "fade", time = 500 })
	print("["..composer.getSceneName('current').."]" ,"END EVENT: ", event.name)
end
-------------------------------------restart_app-END------------------------------ 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "restart_app", scene )

print("END SCENE: ", scene.name)
print("SCENE-COMPLETE.LUA", "START")
return scene
