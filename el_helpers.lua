---Get an array of keys from a table.
---@param tab table - Table to get keys from.
---@return table - Array of keys.
---@usage local keys = get_keys({["a"] = 1, ["b"] = 2, ["c"] = 3}) -- keys = {"a", "b", "c"}
function keys(var)
    local keyset={}
    local n=0

    for k, _ in pairs(var) do
        n=n+1
        keyset[n]=k
    end
    return keyset
end

---Check if Array has value.
---@param tab table - Table to check.
---@param val string - Value to check for.
---@return boolean - True if value is present, false if value is missing.
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end