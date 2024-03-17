push = require '/lib/push'
Class = require '/lib/class'

require '/src/snake'
require '/src/food'

WINDOW_WIDTH = 1280 
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

FIELD_SIZE = 8

UPDATE_RATE = 0.1

TOTALPOINTS = 459

state = 'start'

snake = snake(VIRTUAL_WIDTH / 2 - 4, VIRTUAL_HEIGHT / 2 - 4)

local timeCount = 0 
local points = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Snake')

    smallFont = love.graphics.setNewFont(12)
    bigFont = love.graphics.setNewFont(20)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    food = food(snake)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'return' then
        if state == 'lose' or state == 'win' then
            snake:reset()
            food:newPosition()
        end

        state = 'move'
    end

    if state == 'move' then
        if snake.dir == 'horizontal' then
            if key == 'down' then
                moveBuffer = 'down'
            elseif key == 'up'then
                moveBuffer = 'up'
            end
        elseif snake.dir == 'vertical' then
            if key == 'right' then
                moveBuffer = 'right'
            elseif key == 'left'then
                moveBuffer = 'left'
            end
        end
    end
end

function love.update(dt)
    if state == 'move' then
        if snake:colides() then
            state = 'lose'
        end

        timeCount = timeCount + dt

        if timeCount >= UPDATE_RATE then
            if state == 'move' then
                if moveBuffer == 'right' or moveBuffer == 'down' then
                    snake.move = SNAKE_SPEED
                else
                    snake.move = -SNAKE_SPEED
                end
                
                if moveBuffer == 'right' or moveBuffer == 'left' then
                    snake.dir = 'horizontal'
                else
                    snake.dir = 'vertical'
                end
            end

            snake:update()
            timeCount = timeCount % UPDATE_RATE
        end

        if snake:eatsFood(food.x, food.y) then
            snake:grow()
            food:newPosition()
        end

        if points == TOTALPOINTS then
            state = 'win'
        end
    end
end

function drawField()
    love.graphics.setColor(162/255, 193/255, 139/255, 1)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 116, VIRTUAL_HEIGHT / 2 - 76, 232, 8)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 116, VIRTUAL_HEIGHT / 2 - 76, 8, 152)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 116, VIRTUAL_HEIGHT / 2 + 68, 232, 8)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 108, VIRTUAL_HEIGHT / 2 - 76, 8, 152)
end

function love.draw()
    push:start()

    love.graphics.clear(20/255, 55/255, 15/255, 0.8)

    love.graphics.setFont(smallFont)

    if state == 'start' then
        love.graphics.printf('Press enter to start', 0, 0, VIRTUAL_WIDTH, 'center')
    elseif state == 'lose' then
        love.graphics.setFont(bigFont)
        love.graphics.printf('You Lose!', 0, 0, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press enter to restart', 0, 22, VIRTUAL_WIDTH, 'center')
    elseif state == 'win' then
        love.graphics.setFont(bigFont)
        love.graphics.printf('You Win! Congrats', 0, 0, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press enter to restart', 0, 22, VIRTUAL_WIDTH, 'center')
    end

    drawField()
    snake:render()
    food:render()

    push:finish()
end