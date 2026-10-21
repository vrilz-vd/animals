local url = "https://raw.githubusercontent.com/vrilz-vd/animals/main/ui.lua"
local success, result = pcall(game:HttpGet, url)
if success then
    loadstring(result)()
else
    warn("Gagal download UI")
end
