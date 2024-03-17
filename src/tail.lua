tail = Class{}

function tail:init(x, y)
    self.x = x
    self.y = y
    self.width = 8
    self.height = 8

    self.tail = nil
end

function tail:update(x, y, dir)
    oldx = self.x
    oldy = self.y
    olddir = self.dir

    self.x = x
    self.y = y
    self.dir = dir
    
    if self.tail ~= nil then
        self.tail:update(oldx, oldy, olddir)
    end
end

function tail:newTail(head)
    aux = head.tail
    head.tail = tail(self.x, self.y)
    head.tail.tail = aux
end

function tail:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    if self.tail ~= nil then
        self.tail:render()
    end
end