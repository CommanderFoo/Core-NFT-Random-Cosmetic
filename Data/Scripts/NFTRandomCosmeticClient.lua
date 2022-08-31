local COSMETIC_TOKENS = require(script:GetCustomProperty("CosmeticTokens"))

local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local LOADING = script:GetCustomProperty("Loading"):WaitForObject()
local PROGRESS_BAR = script:GetCustomProperty("ProgressBar"):WaitForObject()

local LOCAL_PLAYER = Game.GetLocalPlayer()
local tokens = {}

LOADING:LookAtContinuous(LOCAL_PLAYER, true)

local function OnTriggerEnter(trigger, other)
	if other == LOCAL_PLAYER then
		Events.BroadcastToServer("Cosmetic.Attach")
	end
end

for index, row in ipairs(COSMETIC_TOKENS) do
	local token, success, msg = Blockchain.GetToken("0x495f947276749ce646f68ac8c248420045cb7b5e", tostring(row.TokenID))

	if success == BlockchainTokenResultCode.SUCCESS then
		tokens[#tokens + 1] = token
		
		local scale = PROGRESS_BAR:GetScale()

		scale.z = (4 / #COSMETIC_TOKENS) * #tokens
		PROGRESS_BAR:SetScale(scale)
	else
		warn(msg)
	end

	Task.Wait(1.6)
end

LOADING:StopRotate()
LOADING.visibility = Visibility.FORCE_OFF
TRIGGER.collision = Collision.FORCE_ON

TRIGGER.beginOverlapEvent:Connect(OnTriggerEnter)