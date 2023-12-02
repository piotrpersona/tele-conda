" Title:        tele-conda
" Description:  Plugin to select pylsp based on active conda environments. 
" Maintainer:   Piotr Persona <https://github.com/piotrpersona>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_tele_conda_plugin")
    finish
endif
let g:loaded_tele_conda_plugin = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/tele-conda/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 TeleCondaEnv lua require("tele-conda").select_env()
