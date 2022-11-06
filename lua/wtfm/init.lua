local M = {}

M.yank_diagnostic = function()
    -- diagnostic_lnum = getcurpos_lnum - 1
    local lnum = vim.fn.getcurpos()[2]
    local diagnostics = vim.diagnostic.get(0, {lnum = lnum - 1})

    -- if 0 diagnostics nothing to do
    -- if 1 diagnostic copy to clipboard
    -- if n > 1 diagnostics vim.ui.select
    -- vim.fn.setreg('+', msg)
    -- 'No more valid diagnostics to move to'

    -- Yes I understand that this will stop at the first nil value and I'm ok
    -- with it, as there should be no "holes" in diagnostics.
    local len = #diagnostics

    if len == 0 then
        print('No diagnostics on line ' .. lnum)
        return
    end

    if len == 1 then
        vim.fn.setreg('+', diagnostics[1].message)
        print('diagnostic yanked')
        return
    end

    vim.ui.select(diagnostics, {
        prompt = 'Select diagnostic:',
        format_item = function(d)
            return d.source .. ': ' .. d.message
        end,
    }, function(_, i)
        vim.fn.setreg('+', diagnostics[i].message)
        print('diagnostic yanked')
    end)
end

return M
