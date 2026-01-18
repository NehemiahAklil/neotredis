local M = {}

-- 1. Convert hex string to RGB table
function M.hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	-- Handle both 3-digit and 6-digit hex codes
	if #hex == 3 then
		hex = hex:gsub("(.)", "%1%1")
	end
	return {
		tonumber(hex:sub(1, 2), 16),
		tonumber(hex:sub(3, 4), 16),
		tonumber(hex:sub(5, 6), 16),
	}
end

-- 2. Convert RGB (0-255) to HSL (0-360, 0-100, 0-100)
function M.rgb_to_hsl(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, l

	l = (max + min) / 2

	if max == min then
		h, s = 0, 0 -- achromatic (gray)
	else
		local d = max - min
		s = l > 0.5 and d / (2 - max - min) or d / (max + min)

		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	-- Return values in standard CSS units
	return h * 360, s * 100, l * 100
end

-- Convert hex colors to HSL (great for CSS work!)
function M.hex_to_HSL(hex)
	-- Your existing color conversion functions here
	local rgb = M.hex_to_rgb(hex)
	local h, s, l = M.rgb_to_hsl(rgb[1], rgb[2], rgb[3])
	return string.format("hsl(%d, %d%%, %d%%)", math.floor(h + 0.5), math.floor(s + 0.5), math.floor(l + 0.5))
end

function M.replace_hex_with_HSL()
	local line_number = vim.api.nvim_win_get_cursor(0)[1]
	local line_content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

	-- Find and replace hex codes
	for hex in line_content:gmatch("#[0-9a-fA-F]+") do
		local hsl = M.hex_to_HSL(hex)
		line_content = line_content:gsub(hex, hsl)
	end

	vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { line_content })
end

-- Copy relative path of current file to clipboard
function M.copy_to_clipboard(has_current_line)
	local current_file_name = vim.fn.expand("%")
	local relative_path = vim.fn.fnamemodify(current_file_name, ":.")

	if has_current_line then
		relative_path = relative_path .. ":" .. vim.fn.line(".")
	end

	vim.fn.setreg("+", relative_path)

	local message = has_current_line and "Copied with line: " or "Copied path: "
	vim.notify(message .. relative_path, vim.log.levels.INFO)
end

return M
