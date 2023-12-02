local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local actions_state = require "telescope.actions.state"

local split_to_table = function(text, sep)
    local tab = {}
    for s in text:gmatch(sep) do
        table.insert(tab, s)
    end
    return tab
end

local list_conda_envs = function()
    local output = vim.fn.system { 'conda', 'env', 'list' }
    local raw_envs_list = split_to_table(output, "[^\r\n]+")
    table.remove(raw_envs_list, 1)
    table.remove(raw_envs_list, 1)
    local envs = {}
    for _, raw_env in pairs(raw_envs_list) do
        local env = split_to_table(raw_env, "%S+")[2]
        table.insert(envs, env)
    end
    return envs
end

local tele_conda = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        finder = finders.new_table({
            results = list_conda_envs()
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(bufnr, _)
            actions.select_default:replace(function()
                actions.close(bufnr)
                local selection = actions_state.get_selected_entry()
                vim.g.python3_host_prog = selection[1]
                vim.fn.system { 'conda', 'activate', selection[1] }
            end)
            return true
        end
    }):find()
end

tele_conda()

