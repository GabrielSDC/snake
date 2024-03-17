require 'src/tail'

SNAKE_SPEED = 8

snake = Class{}

function snake:init(x, y) 
    self.x = x
    self.y = y
    self.width = 8
    self.height = 8
    self.dir = 'horizontal'
    self.move = SNAKE_SPEED
    self.isNew = true

    self.tail = tail(self.x, self.y)
end

function snake:update()
    x = self.x
    y = self.y
    dir = self.dir

    if self.dir == 'horizontal' then
        self.x = self.x + self.move
    elseif self.dir == 'vertical' then
        self.y = self.y + self.move
    end

    self.tail:update(x, y, dir)
end

function snake:colides()
    if self.x < VIRTUAL_WIDTH / 2 - 108 or self.x > VIRTUAL_WIDTH / 2 + 100 or 
       self.y < VIRTUAL_HEIGHT / 2 - 68 or self.y > VIRTUAL_HEIGHT / 2 + 60 then
        return true
    end

    if not self.isNew then
        aux = self.tail
        while aux ~= nil do 
            if self.x == aux.x and self.y == aux.y then
                return true
            end

            aux = aux.tail
        end
    end

    return false
end

function snake:reset()
    self.x = VIRTUAL_WIDTH / 2 - 4
    self.y = VIRTUAL_HEIGHT / 2 - 4
    self.dir = 'horizontal'
    self.isNew = true

    self.tail.tail = nil
end

function snake:eatsFood(x, y)
    if self.x == x and self.y == y then 
        return true
    end

    return false
end

function snake:grow()
    self.tail:newTail(self)
    self.isNew = false
end

function snake:render()
    love.graphics.setColor(178/255, 230/255, 172/255, 0.8)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    self.tail:render()
end