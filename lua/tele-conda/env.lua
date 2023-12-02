local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

local M = {}

local split_to_table = function(text, sep)
    local tab = {}
    for s in text:gmatch(sep) do
        table.insert(tab, s)
    end
    return tab
end

local list_conda_envs = function(envs)
    local output = vim.fn.system({ "conda", "env", "list" })
    local raw_envs_list = split_to_table(output, "[^\r\n]+")
    table.remove(raw_envs_list, 1)
    table.remove(raw_envs_list, 1)
    local env_names = {}
    for _, raw_env in pairs(raw_envs_list) do
        local env_info = split_to_table(raw_env, "%S+")
        local env_name = env_info[1]
        local env_path = env_info[#env_info]
        table.insert(env_names, env_name)
        envs[env_name] = env_path
    end
    envs['base'] = envs['base'] .. '/base'
    return env_names
end

function M.select_env(opts)
    local envs = {}
    opts = opts or {}
    pickers
        .new(opts, {
            finder = finders.new_table({
                results = list_conda_envs(envs),
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(bufnr, _)
                actions.select_default:replace(function()
                    actions.close(bufnr)
                    local selected_env = actions_state.get_selected_entry()[1]
                    local env_path = envs[selected_env]
                    local python_bin = env_path .. "/bin/python"
                    vim.g.python3_host_prog = python_bin
                    --vim.fn.system { 'conda', 'activate', selection[1] }
                end)
                return true
            end,
        })
        :find()
end

return M
