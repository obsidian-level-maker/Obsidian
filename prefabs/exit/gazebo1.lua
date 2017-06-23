--
-- Exit gazebo
--

PREFABS.Exit_gazebo1 =
{
  file   = "exit/gazebo1.wad"
  map    = "MAP01"

  rank   = 2
  prob   = 100

  where  = "seeds"
  seed_w = 2
  seed_h = 2

  open_to_sky = 1

  x_fit  = "frame"
}


------- Exit-to-Secret ---------------------------


UNFINISHED.Exit_gazebo1_secret =
{
  template = "Exit_gazebo1"

  kind = "secret_exit"

  -- replace normal exit special with "exit to secret" special
  line_11 = 51

}


