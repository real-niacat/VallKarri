if not vallkarri.config.http_allowed then
    return
end

local function set_librat_pondere(code, body, headers)
	if body and code == 200 then
        local r = to_number(string.match(body, '"red"%s*:%s*(%d+)'))
        local b = to_number(string.match(body, '"blue"%s*:%s*(%d+)'))
		vallkarri.librat_vals = {
            red = r,
            blue = b,
            method = "https"
        }
    end
end

local function set_last_message(code, body, headers)
    if body and code == 200 then
		vallkarri.last_message = body or ""
    end
end

local function do_nothing_and_fucking_die(code, body, headers)

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

function vallkarri.count_player()
    if not succ then return end

    https.asyncRequest("https://celestial.moe:3000/countplayer", do_nothing_and_fucking_die)
end

function vallkarri.send_discord_message(message, channel_id)

    if not succ then return end
    if not channel_id then
        channel_id = "1381059071800512554"
    end
    
    local options = {
        headers = {
            ["Content-Type"] = "application/json"
        },
        data = "{\"message\":\"" .. message .. "\", \"channel_id\": \"" .. channel_id .. "\"}"
    }
    https.asyncRequest("https://celestial.moe:3000/send-message", options, do_nothing_and_fucking_die)

end