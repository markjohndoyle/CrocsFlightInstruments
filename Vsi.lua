--[[
VSI - Vertical Speed Indicator.
Not strictly true presently as it just displays your pitch and airspeed

@author Mark Doyle (markjohndoyle@googlemail.com)
@version 0.0.1-SNAPSHOT

]]--
local TRANSPARENT = { ["red"] = 0, ["green"] = 0, ["blue"] = 0, ["alpha"] = 0  };
local trace = false;

-- Gets the attitude pitch in degrees rounded to 0 decimal places
local function getAttitude()
	if (IsFlying()) then
		local radians = GetUnitPitch("player");
		local degree = (180/3.14) * radians;
		return math.floor(degree);
	else 
		return "---";
	end
end

-- Gets the speed in miles per hour
local function getSpeed()
	yards = GetUnitSpeed("player");
	meters = yards * 0.9144;
	return math.floor(meters);
end

local function getColour(red, green, blue, alpha)
	local colour = {};
	colour["red"] = red;
	colour["green"] = green;
	colour["blue"] = blue;
	colour["alpha"] = alpha;
	return colour;
end

local function setPitchBars(attitude)
	-- if the attitude is not a number (for reasons this function doesn't care about)
	-- set them bars to level flight.
	if (type(attitude) ~= "number") then
		vsiFrame.posAttitudeBar:SetValue(0);
		vsiFrame.negAttitudeBar:SetValue(90);
	else
		minValue, maxValue = vsiFrame.negAttitudeBar:GetMinMaxValues();
		-- if we are in level flight
		if(attitude == 0) then
			-- the neg bar is black to simulate it filling "downwards" so we must set it to full, i.e., 90
			vsiFrame.posAttitudeBar:SetValue(attitude);
			vsiFrame.negAttitudeBar:SetValue(maxValue);
		elseif(attitude > 0) then
			vsiFrame.posAttitudeBar:SetValue(attitude);
			vsiFrame.negAttitudeBar:SetValue(maxValue);
		elseif (attitude < 0) then
			vsiFrame.posAttitudeBar:SetValue(0);
			vsiFrame.negAttitudeBar:SetValue(maxValue + attitude);
		end
	end
end

-- Updates the widgets with the calculated info
-- TODO Might needt o throttle this.  Doesn't do much at the minute though.
function vsiFrame_OnUpdate(self, elapsed)	
	att = getAttitude();

	-- TODO - Move to seperate function
	-- If the attitude is a number - i.e. we are flying
	if (type(att) == "number") then
		-- get a colour for the widgets based upon the attitude value
		local posBarColour; -- also used for text colour hence why is it not transparent in negative pitch
		local negBarColour;
		local negBackdropColour;
		-- if in...
		if(att == 0) then -- level flight
			posBarColour = getColour(0, 155, 255, 1);
			negBarColour = getColour(0, 0, 0, 1);
			negBackdropColour = getColour(0, 0, 0, 0);
		elseif(att < 0) then -- negative pitch
			posBarColour = getColour(255, 0, 0, 1);
			negBarColour = getColour(0, 0, 0, 1);
			negBackdropColour = getColour(255, 0, 0, 1);
		elseif (att > 0) then -- positive pitch
			posBarColour = getColour(0, 255, 0, 1);
			negBarColour = getColour(0, 0, 0, 1);
			negBackdropColour = getColour(0, 0, 0, 0);
		end

		-- set the widget colours
		attitudeText:SetTextColor(posBarColour.red, posBarColour["green"], posBarColour["blue"], posBarColour["alpha"]);
		vsiFrame.posAttitudeBar:SetStatusBarColor(posBarColour["red"], posBarColour["green"], posBarColour["blue"], posBarColour["alpha"]);
		vsiFrame.negAttitudeBar:SetBackdropColor(negBackdropColour["red"], negBackdropColour["green"], negBackdropColour["blue"], negBackdropColour["alpha"]);
	end
	
	-- set the pitch bars
	setPitchBars(att);
	-- set attitude text to display degrees pitch and mph (airspeed)
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
	-- Set the positive bar's backdrop and the negative bar's bar to black in order to create the illusion of a single attitude bar
	vsiFrame.posAttitudeBar:SetBackdropColor(0, 0, 0, 1);
	vsiFrame.negAttitudeBar:SetStatusBarColor(0, 0, 0, 1);
end

-- Run - move to OnLoad?
SLASH_VSI1 = "/vsi";
SlashCmdList["VSI"] = slashCmd;