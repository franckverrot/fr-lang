# FR (Functional Ruby) language


4-hour experiment at:

* Creating a minimal language in Ruby
* Language will look like Haskell


## Example file

```haskell
foo :: Int
foo = 42 * 2

bar :: Int
bar = foo

baz :: String
baz = "test"

add' :: Int -> Int -> Int
add' a b = a + b

add'1 :: Int -> Int
add'1 a = add' 1 a

main = add'1 41
```


## USAGE

    ./fr example.fr

    n{42}

A debug mode is also supported, who yield sexps (and hence looks very similar to a LISP):

    DEBUG=1 ./fr example.fr

```lisp
(defn (#foo :: (NumberType))
  []
  (#(mul[n{42}, n{2}])))

(defn (#bar :: (NumberType))
  []
  (#(foo[])))

(defn (#baz :: (StringType))
  []
  (s{"test"}))

(defn (#add' :: (NumberType, NumberType, NumberType))
  [a, b]
  (#(add[#(a[]), #(b[])])))

(defn (#add'1 :: (NumberType, NumberType))
  [a]
  (#(add'[n{1}, #(a[])])))

(defn (#main :: [])
  []
  (#(add'1[n{41}])))

(defn (#add :: [])
  [x, y]
  (<native_rb>))

(defn (#sub :: [])
  [x, y]
  (<native_rb>))

(defn (#mul :: [])
  [x, y]
  (<native_rb>))

(defn (#div :: [])
  [x, y]
  (<native_rb>))
```

NOTES:

* n{x} are wrapped integers
* There's no REPL yet


## LIMITATIONS

* Currying is not supported
* Signatures aren't enforced yet, nor checked

## LICENSE

GPLv3
