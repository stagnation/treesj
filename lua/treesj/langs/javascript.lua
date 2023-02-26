local u = require('treesj.langs.utils')

return {
  object = u.set_preset_for_dict(),
  object_pattern = u.set_preset_for_dict(),
  array = u.set_preset_for_list(),
  array_pattern = u.set_preset_for_list(),
  formal_parameters = u.set_preset_for_args(),
  arguments = u.set_preset_for_args(),
  named_imports = u.set_preset_for_dict(),
  export_clause = u.set_preset_for_dict(),
  body = u.set_preset_for_statement({
    join = {
      filter = {
        u.filter.skip_nodes_if_one_named({ '{', '}' }),
      },
    },
    split = {
      non_bracket_node = true,
      add_framing_nodes = { left = '{', right = '}' },
      foreach = function(tsj)
        if tsj:next() and tsj:next():is_last() then
          tsj:_update_text('return ' .. tsj:text())
        end
      end,
    },
  }),
  statement_block = u.set_preset_for_statement({
    join = {
      filter = {
        u.filter.skip_nodes_if_one_named({ '{', '}' }),
      },
      foreach = function(tsj)
        if tsj:is_last() then
          local text = string.gsub(tsj:text(), 'return ', '')
          text = string.gsub(text, ';$', '')
          tsj:_update_text(text)
        end
      end,
      no_insert_if = {
        'function_declaration',
        'try_statement',
        'if_statement',
      },
    },
  }),
  arrow_function = {
    target_nodes = { 'body' },
  },
  lexical_declaration = {
    target_nodes = { 'array', 'object' },
  },
  variable_declaration = {
    target_nodes = { 'array', 'object' },
  },
  assignment_expression = {
    target_nodes = { 'array', 'object' },
  },
  try_statement = {
    target_nodes = {
      'statement_block',
    },
  },
  function_declaration = {
    target_nodes = {
      'statement_block',
    },
  },
  ['function'] = {
    target_nodes = {
      'statement_block',
    },
  },
  catch_clause = {
    target_nodes = {
      'statement_block',
    },
  },
  finally_clause = {
    target_nodes = {
      'statement_block',
    },
  },
  export_statement = {
    target_nodes = { 'export_clause', 'object' },
  },
  import_statement = {
    target_nodes = { 'named_imports', 'object' },
  },
  if_statement = {
    target_nodes = {
      'statement_block',
      'object',
    },
  },
  jsx_opening_element = u.set_default_preset({
    both = {
      omit = { 'identifier', 'nested_identifier' },
    },
  }),
  jsx_element = u.set_default_preset({
    join = {
      space_separator = 0,
    },
  }),
  jsx_self_closing_element = u.set_default_preset({
    both = {
      omit = { 'identifier', 'nested_identifier', '>' },
      no_format_with = {},
    },
  }),
}
