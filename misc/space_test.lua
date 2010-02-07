---
--- Space Generation Test
---


gui =
{
  random = function() return math.random() end
}

require 'util'


SEED_W = 32
SEED_H = 32

SEEDS = array_2D(SEED_W, SEED_H)


function generate()
  for y = 1,SEED_H do
    for x = 1,SEED_W do
      SEEDS[x][y] = rand_index_by_probs({ 80, 40, 20, 10, 5 }) - 1
    end
  end
end


function write_seeds()
  for y = 1,SEED_H do
    for x = 1,SEED_W do
      print(SEEDS[x][y] or 0)
    end
  end
end


generate()

write_seeds()
