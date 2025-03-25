;; extends

function: (select_expression
  attrpath: (attrpath
    attr: (identifier) @function.call .))

function: (_
  name: (identifier) @function.call)

(variable_expression
  name: (identifier) @module.builtin
    (#any-of? @module.builtin "nixpkgs" "builtins" "lib" "pkgs"))

(select_expression
  expression: (variable_expression)
  attrpath: (attrpath
    attr: (identifier) @module.builtin
      (#any-of? @module.builtin "nixpkgs" "builtins" "lib" "pkgs")))

(binding
  attrpath: (attrpath
    attr: (identifier) @variable)
  (attrset_expression
    (binding_set
      binding: [
        (binding
          attrpath: (attrpath
            attr: (identifier)))
        (inherit)
        (inherit_from)
      ]
      (_))))

(let_expression
  (binding_set
    binding: (binding
      attrpath: (attrpath
        attr: (identifier) @variable))))

(binding
  attrpath: (attrpath
    attr: (identifier) @function)
  expression: (function_expression))

(inherit_from
  expression: (variable_expression
    name: (identifier))
  attrs: (inherited_attrs
    attr: (identifier) @variable.member))

(inherit
  attrs: (inherited_attrs
    attr: (identifier) @variable))
