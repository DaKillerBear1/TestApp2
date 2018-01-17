display.setDefault("anchorX", 0)
display.setDefault("anchorY", 0)

screenw = display.safeActualContentWidth
screenh = display.safeActualContentHeight

local oneMeterScale = 10
local lastTimeMilliseconds = 0
local gravity = 9.81^2
local accelerometerx = 0
local numberOfkicks = 0

local ball = display.newImageRect("ball.png", 75, 75)
ball.x = display.contentCenterX
ball.y = display.contentCenterY
balldx = 0
balldy = 0
yBallbounce = 0.8
xBallbounce = 0.1

local arrow = display.newImageRect("arrow.png", 50, 50)
arrow.x = display.contentCenterX
arrow.y = display.height
arrow.isVisible = false

local counter = display.newText({text = numberOfkicks, x = screenw / 2, y = 40, font = native.newFont("Helvetica-Bold", 40)})

local function onBallTap(event)
	if event.phase == "began" then
		balldy = -800
		numberOfkicks = numberOfkicks + 1
	end
end

function onAccelerate(event)
	accelerometerx = event.xRaw
	print(accelerometerx)
end

local function updateBall(dt)
	balldy = balldy + (gravity * oneMeterScale * dt)
	balldx = balldx + (accelerometerx * 20)
	
	ball.y = ball.y + (balldy * dt)
	ball.x = ball.x + (balldx * dt)

	if balldx > 0 then
		balldx = balldx - (10 * dt)
	elseif balldx < 0 then
		balldx = balldx + (10 * dt)
	end
	
	if ball.y + ball.height > screenh then
		ball.y = screenh - ball.contentHeight
		balldy = -balldy * yBallbounce
	end

	if ball.x + ball.width > screenw then
		ball.x = screenw - ball.contentWidth
		balldx = -balldx * xBallbounce
	elseif ball.x < 0 then
		ball.x = 0
		balldx = -balldx * xBallbounce
	end
end

local function updateArrow()
	if ball.y  < 0 then
		arrow.isVisible = true
		arrow.x = ball.x
	else
		arrow.isVisible = false
	end
end

local function updateCounter()
	counter.text = numberOfkicks
end

function main(event)
	local currentTimeMilliseconds = event.time 
	local dt = (currentTimeMilliseconds * 0.001) - (lastTimeMilliseconds * 0.001)
	
	updateBall(dt)
	updateArrow()
	updateCounter()

	lastTimeMilliseconds = currentTimeMilliseconds
end

ball:addEventListener("touch", onBallTap)
Runtime:addEventListener("enterFrame", main)
Runtime:addEventListener("accelerometer", onAccelerate)
