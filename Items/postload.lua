local function set_librat_pondere(code, body, headers)
	if body and code == 200 then
        local r = to_number(string.match(body, '"red"%s*:%s*(%d+)'))
        local b = to_number(string.match(body, '"blue"%s*:%s*(%d+)'))
		vallkarri.librat_vals = {
            red = r,
            blue = b,
            method = "https"
        }
    else
        print("failed to load librat pondere values properly. please check your internet connection")
        print("fallback values being used")
    end
end

local function set_last_message(code, body, headers)
    if body and code == 200 then
        -- print(body)
        local message_content = string.match(body, '"content"%s*:%s*"([^"]+)"')
		vallkarri.last_message = message_content or ""
    end
end


local succ, https = pcall(require, "SMODS.https")
if succ then
    https.asyncRequest("https://celestial.moe:3000/counts", set_librat_pondere) -- HUGE credit to celestial. this would not be possible without both her help and her server hosting
end

function vallkarri.update_last_message()
    if not succ then
        return
    end

    https.asyncRequest("https://celestial.moe:3000/lastmessage", set_last_message)
end
