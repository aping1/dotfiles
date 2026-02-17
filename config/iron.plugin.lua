local nvim = vim.api
local impromptu = require("impromptu")
local iron = require("iron")

_G.repl_globs = function()
    local globs = _G.split(nvim.nvim_eval('glob(\'~/*-ipython.par\')'))
    local t = "ipython"
    local nopts = {}
    local cb = nvim.nvim_get_current_buf()
    local ft = nvim.nvim_buf_get_option(cb, 'filetype')
    if not ( ft == 'python' ) then
        return
    end
    for _, kv in ipairs(globs) do
        nopts[kv] = {
            description = kv
        }
    end
    impromptu.ask{
        title = "Select preferred ipython exe",
        options = nopts,
        handler = function(_, opt)
            local repl = iron.ll.get_preferred_repl(ft)
            if repl ~= nil then
                repl['command'] = opt.description
                iron.core.add_repl_definitions{[ft] = { ipython = repl }}
                iron.core.set_config{preferred = {[ft] = "ipython"}}
                return true
            else
                return false
            end
        end
    }   
end

_G.set_preferred_repl = function()
    local cb = nvim.nvim_get_current_buf()
    local ft = nvim.nvim_buf_get_option(cb, 'filetype')
    local defs = iron.core.list_definitions_for_ft(ft)
    local opts = {}

    for _, kv in ipairs(defs) do
        if not ( kv[1] == 'venv_python' ) then
            opts[kv[1]] = {
                description = table.concat(kv[2].command, " ")
            }
        end
    end

    for _, kv in ipairs(defs) do
        if not ( kv[1] == 'venv_python' ) then
            if( kv[2].command[1] ~= opts ) then
                opts[kv[2].command[1]] = {
                    description = kv[2].command[1]
                }
            end
        end
    end

    impromptu.ask{
        title = "Select preferred repl",
        options = opts,
        handler = function(_, opt)
            iron.core.set_config{preferred = {[ft] = opt.description}}
            return true
        end
    }
end

_G.dump = function(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. _G.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

_G.split = function (inputstr, sep)
    sep=sep or '%s'
    local t={}
    for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
        table.insert(t,field)
        if s=="" then return t end
    end
end

_G.capture = function(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    return _G.split(s, '[\n\r]+', ' ')
end


_G.set_virtualenv = function()
    local venvs = nvim.nvim_eval('pyenv#pyenv#get_available_envs()')
    local opts = {}
    if venvs then
        for _, kv in ipairs(venvs) do
            opts[kv]= { description = kv }
        end
    else
        print('None')
    end
    impromptu.ask{
        title = "Select venv",
        options = opts,
        handler = function(_, opt)
            nvim.nvim_command('PyenvActivate ' .. opt.description)
            -- nvim.set_var('g:deoplete#sources#jedi#python_path', 'lol')
            return true
        end
    }
end

-- iron.core.set_config{preferred = {python = "venv_python"}}

nvim.nvim_command("command! -nargs=0 PickRepl lua set_preferred_repl()")
nvim.nvim_command("command! -nargs=0 PickVirtualenv lua set_virtualenv()")
nvim.nvim_command("command! -nargs=0 PickIPython lua repl_globs()")

