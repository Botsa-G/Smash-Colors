require "collision"
lume = require "lume"
fonts = {}
fonts.first = love.graphics.newFont("cold.ttf", 56)
fonts.second = love.graphics.newFont("bom.otf", 56)
fonts.third = love.graphics.newFont("cat.ttf", 63)
fonts.fourth = love.graphics.newFont("sup.ttf", 63)
fonts.fifth = love.graphics.newFont("er.TTF", 63)
fonts.sixth = love.graphics.newFont("Lem.ttf", 77)
fonts.seventh = love.graphics.newFont("oh.ttf", 63)
fonts.eight = love.graphics.newFont("mod.ttf", 93)

sound = {}
sound.hit = love.audio.newSource("hitten.wav", "static")
sound.crush = love.audio.newSource("broken.wav", "static")
sound.background = love.audio.newSource("bil.ogg", "static")

faces = {
    x = 0,
    y = 0,
    sx = 1,
    sy = 1,
    imgno = 4,
    alpha = 1,
    img = love.graphics.newImage("4.png")
}

function faces:new(tabl)
    tab = tabl or {}
    setmetatable(tabl, self)
    self.__index = self
    return tabl
end

function faces:draw()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.img, self.x, self.y, 0, self.sx, self.sy, self.img:getWidth() * 0.5,
        self.img:getHeight() * 0.5)
    love.graphics.setColor(1, 1, 1, 1)
end

-- (face,joe.x,joe.y,0,0.9,0.75,face:getWidth()*0.5,face:getHeight()*0.5)

fumes = {}
function create_fume(x, y, r, l)
    fume = {}
    fume.x = x
    fume.y = y
    fume.r = r
    fume.l = l
    fumes[#fumes + 1] = fume
end

player = {
    x = 60,
    y = 500,
    corner = 0,
    w = 67,
    h = 30,
    color = math.floor(love.math.random(1, 5)),
    r = 0,
    g = 1,
    b = 0,
    position = math.floor(love.math.random(1, 4)),
    shrink = false,
    alpha = 1,
    x_speed = 1,
    y_speed = 1,
    life_time = 1
}
function player:new(tab)
    tab = tab or {}
    setmetatable(tab, self)
    self.__index = self
    return tab
end

function player:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.setColor(self.r, self.g, self.b, self.alpha)
    love.graphics.rectangle("fill", -self.w / 2, -self.h / 2, self.w, self.h, self.corner)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()

end

walls = {}
function create_wall(tabl)
    walls[#walls + 1] = player:new(tabl)
end

explos = {}
function create_explo(tab)
    explos[#explos + 1] = player:new(tab)
end

function explode(xp, yp, color)

    for i = 1, 360, 4 do
        create_explo({
            color = color,
            x = xp,
            y = yp,
            w = 3,
            h = 3,
            position = i,
            x_speed = love.math.random(14, 20),
            y_speed = love.math.random(14, 20),
            life_time = love.math.random()
        })
    end

end

function explode2(xp, yp, color)

    for i = 1, 360, 10 do
        create_explo({
            color = color,
            x = xp,
            y = yp,
            w = 3,
            h = 3,
            position = i,
            x_speed = love.math.random(22, 27),
            y_speed = love.math.random(15, 20),
            life_time = love.math.random()
        })
    end

end

color_number = {1, 2, 3, 4, 5}

function shuffle(arr)
    for i = 1, #arr - 1 do
        local choice = math.floor(love.math.random(i, #arr))
        arr[i], arr[choice] = arr[choice], arr[i]
    end
end

local best = 0

---saving
function save()

    game = {}
    game.highest = {
        high = best
    }
    saved = lume.serialize(game)
    love.filesystem.write("savedata.txt", saved)
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function love.load()

    -- loading highscore if saved
    if love.filesystem.getInfo("savedata.txt") then
        file = love.filesystem.read("savedata.txt")
        game = lume.deserialize(file)
        best = game.highest.high
    else
        best = 0
    end

    -- create_wall()

    joe = player:new({
        corner = 7
    })
    guy = player:new({
        x = 180,
        y = 240,
        w = 85,
        h = 40,
        corner = 7,
        alpha = 0
    })
    guy_a = player:new({
        x = 180,
        y = 310,
        w = 90,
        h = 45,
        corner = 7,
        alpha = 1,
        color = math.floor(love.math.random(1, 5))
    })

    face = faces:new({
        x = joe.x,
        y = joe.y,
        sx = 0.9,
        sy = 0.72,
        imgno = 1,
        img = love.graphics.newImage("4.png")
    })
    face2 = faces:new({
        x = guy.x,
        y = guy.y,
        sx = 1,
        sy = 0.9,
        img = love.graphics.newImage("2.png")
    })
    face3 = faces:new({
        x = guy_a.x,
        y = guy_a.y,
        sx = 1,
        sy = 0.9,
        img = love.graphics.newImage("3.png")
    })
    hs = faces:new({
        x = guy.x,
        y = guy.y - 20,
        sx = 1.4,
        sy = 1.2,
        img = love.graphics.newImage("hes2.png")
    })
    hs2 = faces:new({
        x = guy_a.x,
        y = guy_a.y - 20,
        sx = 1.5,
        sy = 1.3,
        img = love.graphics.newImage("hes2.png")
    })

    intro = faces:new({
        x = 180,
        y = -200,
        sx = 0.15,
        sy = 0.15,
        img = love.graphics.newImage("lo2.png")
    }) -- y= 300

end

local speed = 100
local walls_in = 0
local motiont = 0
local score = 0
local pick = 0

shuffle(color_number)
for i = 1, 5 do
    create_wall({
        x = 72 * i - 36,
        y = 200,
        w = 72,
        h = 40,
        color = color_number[i]
    })
end

local win = 2
local shakes = 0
local fade = 0
fade2 = 1
local final_alpha = 0

angry = {2, 5}
f_alpha = 1

local cool = 0
local esc_count = 0
local q_alpha = 0
local resets = 3
local hold_on = 1.2
local intro_alpha = 1

function love.update(dt)

    save()

    face.x = joe.x
    face.y = joe.y
    face.img = love.graphics.newImage(face.imgno .. ".png")
    face2.img = love.graphics.newImage(face2.imgno .. ".png")

    if win == 1 then
        sound.background:setVolume(50)
        sound.background:play()
    else
        sound.background:stop()
        sound.background:setVolume(0)
    end

    if shakes > 0 then
        shakes = shakes - 3 * dt
    end

    walls_in = walls_in + dt

    if motiont > 0 then
        motiont = motiont - dt
    end

    for i = 1, #walls do
        mt = walls[i]
        if mt.color == 1 then
            mt.r = 0.6
            mt.g = 0
            mt.b = 0.6
        end
        if mt.color == 2 then
            mt.r = 1
            mt.g = 0.5
            mt.b = 0
        end
        if mt.color == 3 then
            mt.r = 0
            mt.g = 0.5
            mt.b = 0
        end
        if mt.color == 4 then
            mt.r = 0
            mt.g = 0
            mt.b = 0.7
        end
        if mt.color == 5 then
            mt.r = 0.5
            mt.g = 0
            mt.b = 0
        end

        if win == 1 or 0 then
            mt.y = mt.y + speed * dt
        end

    end

    if walls_in > pick then
        shuffle(color_number)
        for i = 1, 5 do
            create_wall({
                x = 72 * i - 36,
                y = -100,
                w = 72,
                h = 40,
                color = color_number[i]
            })
        end
        if score <= 7 then
            pick = math.floor(love.math.random(2.5, 3))
        end
        if score > 7 then
            pick = math.floor(love.math.random(1.77, 2.57))
        end
        walls_in = 0
    end

    if joe.color == 1 then
        joe.r = 0.6
        joe.g = 0
        joe.b = 0.6
    end
    if joe.color == 2 then
        joe.r = 1
        joe.g = 0.5
        joe.b = 0
    end
    if joe.color == 3 then
        joe.r = 0
        joe.g = 0.5
        joe.b = 0
    end
    if joe.color == 4 then
        joe.r = 0
        joe.g = 0
        joe.b = 0.7
    end
    if joe.color == 5 then
        joe.r = 0.5
        joe.g = 0
        joe.b = 0
    end

    joe.x = (72 * joe.position - 36)

    for i = #walls, 1, -1 do
        mt = walls[i]
        if mt.x > 700 or mt.shrink == true then
            table.remove(walls, i)
        end
    end

    for i = 1, #explos do
        mt = explos[i]
        mt.x = mt.x + math.cos(mt.position) * mt.x_speed * 2 * dt
        mt.y = mt.y + math.sin(mt.position) * mt.y_speed * 2 * dt
        mt.y = mt.y + 10 * mt.y_speed * dt
        mt.life_time = mt.life_time - 0.5 * dt -- mt.alpha = mt.alpha - 0.5* dt
    end

    for i = #explos, 1, -1 do
        mt = explos[i]
        if mt.life_time <= 0 then
            table.remove(explos, i)
        end
    end
    -- face.imgno = 1 face.imgno = 5 face.imgno = 6

    for i = 1, #explos do
        mt = explos[i]
        if mt.color == 1 then
            mt.r = 0.75
            mt.g = 0
            mt.b = 0.75
        end
        if mt.color == 2 then
            mt.r = 1
            mt.g = 0.7
            mt.b = 0
        end
        if mt.color == 3 then
            mt.r = 0
            mt.g = 0.7
            mt.b = 0
        end
        if mt.color == 4 then
            mt.r = 0
            mt.g = 0
            mt.b = 0.9
        end
        if mt.color == 5 then
            mt.r = 0.7
            mt.g = 0
            mt.b = 0
        end
    end

    for i = 1, #walls do
        co = walls[i]
        if collide(joe.x, joe.y, joe.w, joe.h, co.x, co.y, co.w, co.h) and co.color == joe.color and win == 1 then
            shakes = 0.1
            co.shrink = true
            explode(co.x, co.y, co.color)
            score = score + 1 * win
            joe.color = math.floor(love.math.random(1, 5))
            sound.hit:setVolume(200)
            sound.hit:play()
        else
            if collide(joe.x, joe.y, joe.w, joe.h, co.x, co.y, co.w, co.h) and co.color ~= joe.color and win == 1 then
                sound.crush:setVolume(200)
                sound.crush:play()
                shakes = 0.5
                explode2(joe.x, joe.y, joe.color)
                face2.imgno = angry[math.floor(love.math.random(1, 2))]
                joe.alpha = 0
                face.alpha = 0
                win = 0
            else
            end
        end
    end

    if win == 0 and fade < 1 then
        fade = fade + dt
    end

    if fade >= 1 then
        final_alpha = 1
    else
        final_alpha = 0
    end

    if love.keyboard.isDown("right") and win == 1 and motiont <= 0 and joe.position < 5 then
        joe.position = joe.position + 1 * win
        motiont = 0.3
    end
    if love.keyboard.isDown("left") and win == 1 and motiont <= 0 and joe.position > 1 then
        joe.position = joe.position - 1 * win
        motiont = 0.3
    end

    if love.keyboard.isDown("r") and win == 0 then
        joe.alpha = 1
        face.alpha = 1
        fade = 0
        walls = {}
        explos = {}
        pick = 0
        score = 0
        win = 1
    end

    if win == 2 then
        f_alpha = 1
    elseif win ~= 2 and f_alpha > 0 then
        f_alpha = f_alpha - 2 * dt
    end

    if love.keyboard.isDown("return") and intro_alpha <= 0 and win == 2 then
        joe.alpha = 1
        face.alpha = 1
        fade = 0
        walls = {}
        explos = {}
        pick = 0
        score = 0
        win = 1
    end

    if love.keyboard.isDown("escape") and cool <= 0 then
        cool = 1
        esc_count = esc_count + 1
        if esc_count < 2 then
            q_alpha = 1
        end
    end

    if esc_count >= 2 then
        love.event.quit()
    end

    if esc_count > 0 then
        resets = resets - dt
    end

    if resets <= 0 then
        resets = 3
        esc_count = 0
    end

    if cool > 0 then
        cool = cool - dt
    end
    if q_alpha > 0 then
        q_alpha = q_alpha - 1 * dt
    end

    if score > best then
        best = score
    end

    guy.r = joe.r
    guy.g = joe.g
    guy.b = joe.b

    if guy_a.color == 1 then
        guy_a.r = 0.6
        guy_a.g = 0
        guy_a.b = 0.6
    end
    if guy_a.color == 2 then
        guy_a.r = 1
        guy_a.g = 0.5
        guy_a.b = 0
    end
    if guy_a.color == 3 then
        guy_a.r = 0
        guy_a.g = 0.5
        guy_a.b = 0
    end
    if guy_a.color == 4 then
        guy_a.r = 0
        guy_a.g = 0
        guy_a.b = 0.7
    end
    if guy_a.color == 5 then
        guy_a.r = 0.5
        guy_a.g = 0
        guy_a.b = 0
    end

    -- if love.keyboard.isDown("x")  then love.filesystem.remove("savedata.txt") love.event.quit() end

    intro.y = lerp(intro.y, 300, 7 * dt)

    if intro.y >= 295 then
        hold_on = hold_on - dt
    end
    if hold_on <= 0 then
        intro.x = lerp(intro.x, -200, 6 * dt)
        hold_on = -1
        if intro_alpha > 0 then
            intro_alpha = intro_alpha - dt
        end
    end

end

function love.draw()

    love.graphics.setColor(0.4, 0.3, 0.3)
    love.graphics.rectangle("fill", 0, 0, 360, 640)
    love.graphics.setColor(1, 1, 1)

    love.graphics.push()

    if shakes > 0 then
        love.graphics.translate(love.math.random(-2, 2), love.math.random(-2, 2))
    end

    for i = 1, #walls do
        mt = walls[i]
        mt:draw()
    end

    joe:draw()
    face:draw()

    for i = 1, #explos do
        mt = explos[i]
        mt:draw()
    end

    love.graphics.pop()

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.first)
    love.graphics.print(score, 160, 30)
    love.graphics.setColor(1, 1, 1)

    if fade < 0.2 then
        love.graphics.setColor(0.4, 0.3, 0.3, 0)
        guy.alpha = 0
        hs.alpha = 0
        face2.alpha = 0
    elseif fade >= 0.2 then
        love.graphics.setColor(0.4, 0.3, 0.3, fade)
        if fade >= 1 then
            guy.alpha = 0.9
            face2.alpha = 0.9
            hs.alpha = 0.9
        end
    end -- (1,1,0.8)
    love.graphics.rectangle("fill", 0, 0, 360, 640)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(fonts.eight)
    love.graphics.setColor(0.01, 0.01, 0.01, final_alpha)
    love.graphics.print(score, 180, 380, 0, 1, 1, love.graphics.getFont():getWidth(score) / 2,
        love.graphics.getFont():getHeight(score) / 2)
    love.graphics.setColor(0.1, 0.2, 0.1, final_alpha)
    love.graphics.setFont(fonts.sixth)
    love.graphics.print('press  "R"  to  restart', 180, 510, 0, 0.35, 0.35,
        love.graphics.getFont():getWidth('press  "R"  to  restart') / 2,
        love.graphics.getFont():getHeight('press  "R"  to  restart') / 2)

    guy:draw()
    face2:draw()
    hs:draw()
    love.graphics.setFont(fonts.seventh)
    love.graphics.setColor(0, 0, 0, final_alpha)
    love.graphics.print(best, 180, 120, 0, 0.75, 0.75, love.graphics.getFont():getWidth(best) / 2,
        love.graphics.getFont():getHeight(best) / 2)
    love.graphics.setFont(fonts.fourth)
    love.graphics.print("BEST", 180, 60, 0, 0.4, 0.4, love.graphics.getFont():getWidth("BEST") / 2,
        love.graphics.getFont():getHeight("BEST") / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont())

    if win == 2 then
        love.graphics.setColor(0.4, 0.3, 0.3, fade2)
    elseif win ~= 2 then
        love.graphics.setColor(0.4, 0.3, 0.3, f_alpha)
    end
    love.graphics.rectangle("fill", 0, 0, 360, 640)
    if win == 2 then
        love.graphics.setColor(0, 0, 0, fade2)
    elseif win ~= 2 then
        love.graphics.setColor(0, 0, 0, f_alpha)
    end
    love.graphics.setFont(fonts.seventh)
    love.graphics.print(' Smash \n    The \n Colors', 180, 70, 0, 0.8, 0.8,
        love.graphics.getFont():getWidth(' Smash \n    The \n Colors') / 2,
        love.graphics.getFont():getHeight(' Smash \n    The \n Colors') / 2)
    if win == 2 then
        love.graphics.setColor(1, 1, 1, fade2)
        guy_a.alpha = fade2
        face3.alpha = fade2
        hs2.alpha = fade2
    elseif win ~= 2 then
        guy_a.alpha = f_alpha
        face3.alpha = f_alpha
        hs2.alpha = f_alpha
        love.graphics.setColor(1, 1, 1, f_alpha)
    end
    guy_a:draw()
    face3:draw()
    hs2:draw()
    if win == 2 then
        love.graphics.setColor(0, 0, 0, fade2)
    elseif win ~= 2 then
        love.graphics.setColor(0, 0, 0, f_alpha)
    end
    love.graphics.setFont(fonts.eight)
    love.graphics.print('Right and Left Keys For Movement', 180, 410, 0, 0.2, 0.2,
        love.graphics.getFont():getWidth('Right and Left Keys For Movement') / 2,
        love.graphics.getFont():getHeight('Right and Left Keys For Movement') / 2)
    love.graphics.print('Play With Sound', 180, 480, 0, 0.4, 0.4,
        love.graphics.getFont():getWidth('Play With Sound') / 2,
        love.graphics.getFont():getHeight('Play With Sound') / 2)
    if win == 2 then
        love.graphics.setColor(0.1, 0.25, 0.1, fade2)
    elseif win ~= 2 then
        love.graphics.setColor(0.1, 0.25, 0.1, f_alpha)
    end
    love.graphics.setFont(fonts.sixth)
    love.graphics.print('Press "Enter" To Start', 180, 550, 0, 0.3, 0.3,
        love.graphics.getFont():getWidth('Press "Enter" To Start') / 2,
        love.graphics.getFont():getHeight('Press "Enter" To Start') / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, q_alpha)
    love.graphics.setFont(fonts.fourth)
    love.graphics.print('Press "ESC" Again To Quit', 180, 300, 0, 0.3, 0.3,
        love.graphics.getFont():getWidth('Press "ESC" Again To Quit') / 2,
        love.graphics.getFont():getHeight('Press "ESC" Again To Quit') / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(0.4, 0.3, 0.3, intro_alpha)
    love.graphics.rectangle("fill", 0, 0, 360, 640)
    intro:draw()
    love.graphics.setColor(1, 1, 1, 1)

end
