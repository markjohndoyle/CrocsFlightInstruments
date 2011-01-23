
-- Gets the attitude pitch in degrees rounded to 0 decimal places
local function getAttitude()
	if (IsFlying()) then
		local radians = GetUnitPitch("player");
		local degree = (180/3.14) * radians
		return math.floor(degree);
	else 
		return "---"
	end
end

-- Gets the speed in miles per hour
local function getSpeed()
	yards = GetUnitSpeed("player");
	meters = yards * 0.9144;
	return math.floor(meters);
end

-- Updates the widgets with the calculated info
function vsiFrame_OnUpdate(self, elapsed)
	att = getAttitude();

	if (type(att) == "number") then
		if(att == 0) then
			attitudeText:SetTextColor(0, 155, 255, 1);
			vsiFrame.attitudeBar:SetStatusBarColor(0, 155, 255, 1);
		elseif(att < 0) then
			attitudeText:SetTextColor(255, 0, 0, 1);
			vsiFrame.attitudeBar:SetStatusBarColor(255, 0, 0, 1);
		elseif (att > 0) then
			attitudeText:SetTextColor(0, 255, 0, 1);
			vsiFrame.attitudeBar:SetStatusBarColor(0, 255, 0, 1);
		end
		
		vsiFrame.attitudeBar:SetValue(att);
	end

	attitudeText:SetText(att .. "°" .. " " .. getSpeed() .. "mph");
end

-- Toggle the VSI frame visibility
local function toggle()
	if (vsiFrame:IsShown()) then
		vsiFrame:Hide();
	else
		vsiFrame:Show();
	end
end

-- currently prints pitch slope in radians
local function slashCmd(msg)
	toggle();
	print(getAttitude() .. " at " .. getSpeed());
end

-- Start up stuff
function vsiFrame_onLoad(self)
end

-- Run - move to OnLoad?
SLASH_VSI1 = "/vsi";
SlashCmdList["VSI"] = slashCmd;