;; extends

(cpp) @keyword.directive

((decl/signature
  name: (variable) @_name
  type: (_))
  (bind
    name: (variable) @variable
    (#eq? @_name @variable)))

((decl/signature
  name: (variable) @_name
  type: (context
    type: (function)))
  (bind
    name: (variable) @function
    (#eq? @_name @function)))

((decl/signature
  name: (variable) @_name
    type: (function))
  (bind
    name: (variable) @function
    (#eq? @_name @function)))

((decl/signature
  name: (variable) @_name)
  (function
    name: (variable) @function
    (#eq? @_name @function)
    (#set! "priority" 101)))

((decl/signature
  name: (variable) @_name
  type: (forall
    (function)))
  (bind
    name: (variable) @function
    (#eq? @_name @function)))

((decl/signature
  name: (variable) @_name
  type: (forall
    (context
      (function))))
  (bind
    name: (variable) @function
    (#eq? @_name @function)))

((decl/signature
  name: (variable) @_name
  type: (list))
  (bind
    name: (variable) @variable
    (#eq? @_name @variable)))

(decl/bind
  name: (variable) @function
  (#eq? @function "main"))

(infix_id
  [
    (variable) @function.call
    (qualified
      (variable) @function.call)
  ])
