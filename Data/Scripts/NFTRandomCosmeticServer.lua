local COSMETICS = require(script:GetCustomProperty("Cosmetics"))
local COSMETIC_TOKENS = require(script:GetCustomProperty("CosmeticTokens"))

local players = {}
local tokens = {}

local function AttachCosmetic(player)
	if players[player] then
		players[player]:Destroy()
	end

	local token = tokens[math.random(#tokens)]

	local color = { CoreString.Split(token:GetAttribute("Color"):GetValue(), ", ") }
	local item = World.SpawnAsset(COSMETICS[tonumber(token:GetAttribute("Box"):GetValue())].Template, { networkContext = NetworkContextType.NETWORKED })

	item:GetChildren()[1]:SetColor(Color.New(color[1], color[2], color[3], 1))
	item:AttachToPlayer(player, "head")
	players[player] = item
end

local function OnPlayerLeft(player)
	if players[player] then
		players[player]:Destroy()
		players[player] = nil
	end
end

for index, row in ipairs(COSMETIC_TOKENS) do
	local token, success, msg = Blockchain.GetToken("0x495f947276749ce646f68ac8c248420045cb7b5e", tostring(row.TokenID))

	if success == BlockchainTokenResultCode.SUCCESS then
		tokens[#tokens + 1] = token
	end

	Task.Wait(1.6)
end

Events.ConnectForPlayer("Cosmetic.Attach", AttachCosmetic)
Game.playerLeftEvent:Connect(OnPlayerLeft)