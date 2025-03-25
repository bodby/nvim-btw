;; extends

((identifier) @module
  (#any-of? @module "vim" "M"))

(field
  name: (identifier) @variable
  value: (table_constructor
    (field)
      (_)))
