#include maps\mp\gametypes\_callbacksetup;

init()
{
    addEventListener("onConnected",     ::onConnected);
    addEventListener("onJoinedAlliesAxis",  ::onJoinedAlliesAxis);
    addEventListener("onSpawnedIntermission",  ::onSpawnedIntermission);

    level thread onTimeoutCalled();
    level thread onTimeoutCancel();
}

onConnected()
{
	self setPlayerObjective();
}

onJoinedAlliesAxis()
{
    self setPlayerObjective();
}

onSpawnedIntermission()
{
    self setPlayerObjective();
}

onTimeoutCalled()
{
    // Timeout can be called durring stratTime (SD) or in middle of the game (other gametypes) - so set correct objective text
    level waittill("running_timeout");
    level thread maps\mp\gametypes\_objective::setAllPlayersObjective();
}

onTimeoutCancel()
{
    // Timeout an be called in middle of the game - so after timeout we need to restore original objective text
    level waittill("timeoutover");
    level thread maps\mp\gametypes\_objective::setAllPlayersObjective();
}



setAllPlayersObjective() {
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] setPlayerObjective();
	}
}

setPlayerObjective()
{

	if (self.sessionstate == "intermission")
	{
        if(game["allies_score"] == game["axis_score"])
    		text = &"MP_THE_GAME_IS_A_TIE";
    	else if(game["allies_score"] > game["axis_score"])
    		text = &"MP_ALLIES_WIN";
    	else
    		text = &"MP_AXIS_WIN";

		self setClientCvar("cg_objectiveText", text);
		return;
	}

	if (level.in_timeout)
	{
		self setClientCvar("cg_objectiveText", game["objective_timeout"]);
		return;
	}

	if (level.in_readyup) {
		self setClientCvar("cg_objectiveText", game["objective_readyup"]);
		return;
	}


	switch (level.gametype)
	{
	case "ctf":
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_CTF_OBJ_TEXT", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_CTF_OBJ_TEXT_NOSCORE");
		break;
	case "dm":
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING_NOSCORE");

		break;
	case "hq":
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_OBJ_TEXT", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_OBJ_TEXT_NOSCORE");

		break;
	case "tdm":
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING1", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING1_NOSCORE");

		break;
	case "sd":

		mode = getcvar("pam_mode");
		if (mode == "bash")
		{
			self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
		}
		else
		{
			if(level.scorelimit > 0)
			{
				if(self.pers["team"] == game["attackers"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_ATTACKERS", level.scorelimit);
				else if(self.pers["team"] == game["defenders"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_DEFENDERS", level.scorelimit);
			}
			else
			{
				if(self.pers["team"] == game["attackers"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_ATTACKERS_NOSCORE");
				else if(self.pers["team"] == game["defenders"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_DEFENDERS_NOSCORE");
			}
		}
		break;
	case "start":

		self setClientCvar("cg_objectiveText", "Special mode used for practicing grenades or smoke, strategic plan making, jump learning and overall game testing.");
	}


}
