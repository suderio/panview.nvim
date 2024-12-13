--[[ this module exposes the interface of lua functions:
define here the lua functions that activate the plugin ]]

--[[ 
PanView Plugin
==============
A Neovim plugin to preview files in Markdown format using Pandoc. 

Features:
- Command `PanViewCurrentBuffer` converts the current buffer to Markdown and displays it in a side buffer.
- Command `PanViewFile` accepts a file path as a parameter, converts it to Markdown, and displays the result in a side buffer.

Both buffers are opened in read-only mode for preview purposes.
]]


local M = {}

local main = require("nvim-panview.main")
local config = require("nvim-panview.config")

--- Converts the current buffer to Markdown and displays it in a side buffer.
-- Detects the filetype of the current buffer, uses Pandoc to convert it to Markdown,
-- and opens the result in a read-only side buffer.
-- Notifies the user if the buffer is unsaved or if the conversion fails.
function M.panview_current_buffer()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == "" then
        vim.notify("Buffer não salvo. Salve o arquivo antes de usar o PanView.", vim.log.levels.ERROR)
        return
    end

    local filetype = main.Detect_filetype(filepath)
    local markdown = main.Convert_to_markdown(filepath, filetype)

    if markdown == "" then
        vim.notify("Falha ao converter o arquivo com Pandoc.", vim.log.levels.ERROR)
        return
    end

    main.Open_side_buffer(markdown)
end

--- Converts a specified file to Markdown and displays it in a side buffer.
-- Accepts a file path as an argument, detects its filetype, converts it to Markdown
-- using Pandoc, and opens the result in a read-only side buffer.
-- Notifies the user if the file is not found or if the conversion fails.
-- @param args table: A table containing the file path as the first argument.
function M.panview_file(args)
    local filepath = args.fargs[1]
    if not filepath or filepath == "" then
        vim.notify("Você deve especificar o caminho de um arquivo.", vim.log.levels.ERROR)
        return
    end

    if vim.fn.filereadable(filepath) == 0 then
        vim.notify("Arquivo não encontrado: " .. filepath, vim.log.levels.ERROR)
        return
    end

    local filetype = main.Detect_filetype(filepath)
    local markdown = main.Convert_to_markdown(filepath, filetype)

    if markdown == "" then
        vim.notify("Falha ao converter o arquivo com Pandoc.", vim.log.levels.ERROR)
        return
    end

    main.Open_side_buffer(markdown)
end

return M
