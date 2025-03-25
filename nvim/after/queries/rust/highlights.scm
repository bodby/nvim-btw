;; extends

(block
  (identifier) @constant .)
(return_expression
  (identifier) @constant .)

(block
  (call_expression
    function: (identifier) @constant) .)

(match_arm
  (call_expression
    function: (identifier) @constant
      (#lua-match? @constant "^[A-Z][a-z_0-9]*$") .))

(scoped_identifier
  path: (identifier)
  name: (identifier) @constant
    (#lua-match? @constant "^[A-Z][a-z_0-9]*$") .)

(use_declaration
  argument: (identifier) @module)

(use_declaration
  argument: [
    (scoped_identifier
      name: (identifier) @module
        (#lua-match? @module "^[a-z_0-9]*$"))
    (use_as_clause
      (scoped_identifier
        name: (identifier) @module
          (#lua-match? @module "^[a-z_0-9]*$")))
  ])

(use_declaration
  (use_as_clause
    path: [
      (identifier) @module
      (scoped_identifier)
    ]
    alias: (identifier) @module))

(use_declaration
  argument: (scoped_use_list
    list: [
      (use_list
        (identifier) @function)
      (use_list
        (scoped_identifier
          name: (identifier) @function))
    ])
  (#lua-match? @function "^[a-z_0-9]*$"))
