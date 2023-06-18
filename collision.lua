function collide(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2 and y1 < y2 + h2 and y1 + h1 > y2
end

function Ccollide(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 - 0.5 * w1 < x2 + 0.5 * w2 and x1 + 0.5 * w1 > x2 - 0.5 * w2 and y1 - 0.5 * h1 < y2 + 0.5 * h2 and y1 +
               0.5 * h1 > y2 - 0.5 * h2
end

function Ycollide(x1, y1, w1, h1, x2, y2, w2, h2)
    return y1 < y2 + h2 and y1 + h1 > y2
end

function tcollide(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2 and y1 + h1 > y2
end

function Xcollide(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2
end

function RXcollide(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2
end

function LXcollide(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 + w1 > x2
end

function dist(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1))
end
