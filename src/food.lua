food = Class{}

function food:init(snake)
    self.x = 0
    self.y = 0
    self.width = 8
    self.height = 8

    self:newPosition(snake)
end

function food:newPosition(snake)
    repeat
        self.x = math.random(18.5, 44.5) * 8
        self.y = math.random(9.5, 25.5) * 8
    until self:isFree(self.x, self.y, snake)
end

function food:isFree(x, y, snake)
    aux = snake
    while aux ~= nil do 
        if aux.x == x and aux.y == y then
            return false
        end

        aux = aux.tail
    end

    return true
end

function food:render()
    love.graphics.setColor(213/255, 45/255, 45/255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end