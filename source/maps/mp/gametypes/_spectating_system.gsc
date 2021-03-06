#include maps\mp\gametypes\_callbacksetup;

init()
{
	if (game["is_public_mode"])
		return;
	if (level.gametype != "sd")
		return;

	addEventListener("onSpawnedSpectator",  ::onSpawnedSpectator);
}

onSpawnedSpectator()
{
	if (self.pers["team"] == "spectator")
	{
		spectator_mode();
	}
}

spectator_mode()
{
	self endon("disconnect");

	wait level.fps_multiplier * .5;

	// DEFINING ARRAY FOR AXIS
	self.health_background_axis = [];
	self.healthbar_axis = [];
	self.playername_axis = [];

	// DEFINING ARRAY FOR ALLIES
	self.health_background_allies = [];
	self.healthbar_allies = [];
	self.playername_allies = [];

	// MAKING AXIS BOXES
	for(i = 0; i < 5; i++)
	{
		y_pos = 120 + (30 * i);
		self making_AXIS_boxes(i, y_pos);
	}

	// MAKING ALLIES BOXES
	for(i = 0; i < 5; i++)
	{
		y_pos = 120 + (30 * i);
		self making_ALLIES_boxes(i, y_pos);
	}

	self filling_boxes();
}

making_AXIS_boxes(i, y)
{
	self endon("disconnect");

	self.healthbar_axis[i] = newClientHudElem(self);
	self.healthbar_axis[i].x = 4;
	self.healthbar_axis[i].y = y + 1;
	self.healthbar_axis[i].horzAlign = "left";
	self.healthbar_axis[i].vertAlign = "top";
	self.healthbar_axis[i].color = (0, 0, .7);
	self.healthbar_axis[i].alpha = 0;
	self.healthbar_axis[i].sort = 1;
	self.healthbar_axis[i].filled = false;
	self.healthbar_axis[i].archived = false;

	self.playername_axis[i] = newClientHudElem(self);
	self.playername_axis[i].x = 8;
	self.playername_axis[i].y = y + 3.5;
	self.playername_axis[i].horzalign = "left";
	self.playername_axis[i].vertalign = "top";
	self.playername_axis[i].sort = 2;
	self.playername_axis[i].fontScale = 1;
	self.playername_axis[i].color = (.8, 1, 1);
	self.playername_axis[i].archived = false;

	self.healthbar_axis[i] setShader(game["health_bar"], 128, 18);
}

making_ALLIES_boxes(i, y)
{
	self endon("disconnect");

	self.healthbar_allies[i] = newClientHudElem(self);
	self.healthbar_allies[i].x = -4;
	self.healthbar_allies[i].y = y + 1;
	self.healthbar_allies[i].horzAlign = "right";
	self.healthbar_allies[i].vertAlign = "top";
	self.healthbar_allies[i].color = (1, 0, 0);
	self.healthbar_allies[i].alignX = "right";
	self.healthbar_allies[i].alpha = 0;
	self.healthbar_allies[i].sort = 1;
	self.healthbar_allies[i].filled = false;
	self.healthbar_allies[i].archived = false;

	self.playername_allies[i] = newClientHudElem(self);
	self.playername_allies[i].x = -8;
	self.playername_allies[i].y = y + 3.5;
	self.playername_allies[i].horzalign = "right";
	self.playername_allies[i].vertalign = "top";
	self.playername_allies[i].alignX = "right";
	self.playername_allies[i].sort = 2;
	self.playername_allies[i].fontScale = 1;
	self.playername_allies[i].color = (.8, 1, 1);
	self.playername_allies[i].archived = false;

	//bar = Int(self.health * 1.28);

	self.healthbar_allies[i] setShader(game["health_bar"], 128, 18);
}

filling_boxes()
{
	self endon("disconnect");

	for(;;)
	{
		if (self.pers["team"] == "spectator")
		{
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if (player.pers["team"] == "allies")
				{
					for(j = 0; j < 5; j++)
					{
						if(self.healthbar_allies[j].filled == false)
						{
							self.playername_allies[j] setplayernamestring(player);
							self.healthbar_allies[j].filled = true;

							health2 = player.health;

							if(isDefined(self.healthbar_allies[j]))
							{
								if (health2 <= 0)
								{
									self.healthbar_allies[j].alpha = 0;
									self.playername_allies[j].alpha = 0.5;
								}
								else
								{
									bar = Int(health2 * 1.28);

									self.healthbar_allies[j].alpha = 1;
									self.healthbar_allies[j] setShader(game["health_bar"], bar, 18);
									self.playername_allies[j].alpha = 1;
								}
							}
							break;
						}

					}
				}
				else if (player.pers["team"] == "axis")
				{
					for(j = 0; j < 5; j++)
					{
						if(self.healthbar_axis[j].filled == false)
						{
							self.playername_axis[j] setplayernamestring(player);
							self.healthbar_axis[j].filled = true;

							health2 = player.health;

							if(isDefined(self.healthbar_axis[j]))
							{
								if (health2 <= 0)
								{
									self.healthbar_axis[j].alpha = 0;
									self.playername_axis[j].alpha = 0.5;
								}
								else
								{
									bar = Int(health2 * 1.28);

									self.healthbar_axis[j].alpha = 1;
									self.healthbar_axis[j] setShader(game["health_bar"], bar, 18);
									self.playername_axis[j].alpha = 1;
								}
							}
							break;
						}
					}
				}
			}
			self unfill_boxes();
			wait level.fps_multiplier * 0.1;
		}
		else
		{
			for(c = 0; c < 5; c++)
			{
				if(isdefined(self.playername_allies[c]))
					self.playername_allies[c] destroy();
				if(isdefined(self.healthbar_allies[c]))
					self.healthbar_allies[c] destroy();
				if(isdefined(self.playername_axis[c]))
					self.playername_axis[c] destroy();
				if(isdefined(self.healthbar_axis[c]))
					self.healthbar_axis[c] destroy();
			}
			return;
		}
	}
}

unfill_boxes()
{
	self endon("disconnect");

	for(r = 0; r < 5; r++)
	{
		if(self.healthbar_allies[r].filled == false)
		{
			self.playername_allies[r] settext(game["empty"]);
			self.healthbar_allies[r] setShader(game["health_bar"], 128, 18);
			self.healthbar_allies[r].alpha = 0;
			self.playername_allies[r].alpha = 1;
		}

		if(self.healthbar_axis[r].filled == false)
		{
			self.playername_axis[r] settext(game["empty"]);
			self.healthbar_axis[r] setShader(game["health_bar"], 128, 18);
			self.healthbar_axis[r].alpha = 0;
			self.playername_axis[r].alpha = 1;
		}
	}

	for(r = 0; r < 5; r++)
	{
		self.healthbar_allies[r].filled = false;
		self.healthbar_axis[r].filled = false;
	}
}
