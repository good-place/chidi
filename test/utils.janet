(import spork/test :prefix "")
(import ../chidi/utils)


(assert
  (= (utils/map-keys string {1 2 3 4}) {"1" 2 "3" 4})
  "returns keys mapped with function")
(assert
  (= (utils/map-keys string {1 2 3 {:a :b :c {:d 3}}})
     {"1" 2 "3" {"a" :b "c" {"d" 3}}})
  "returns keys mapped with function in nested struct")
(assert
  (try
    (utils/map-keys string [1 2 3 {:a :b}])
    ([err] (= err "Data must be dictionary")))
  "errors on non dictionary data")

(assert
  (= (utils/map-vals string {1 2 3 4}) {1 "2" 3 "4"})
  "returns values mapped with function")
(assert
  (= (utils/map-vals type {1 2 3 {:a :b}}) {1 :number 3 :struct})
  "returns values mapped with function in nested struct")
(assert
  (try
    (utils/map-vals string [1 2 3 {:a :b}])
    ([err] (= err "Data must be dictionary")))
  "errors on non dictionary data")

(assert
  (= (utils/select-keys {1 2 3 4 5 6} [1 5]) {1 2 5 6})
  "selects keys from dictionary")
(assert
  (= (utils/select-keys {1 2 3 4 5 6} [1]) {1 2})
  "selects key from dictionary")
(assert
  (= (utils/select-keys {1 2 3 4 5 {:a :b}} [1 5]) {1 2 5 {:a :b}})
  "selects keys from nested dictionary")
(assert
  (try
    (utils/select-keys [1 2 3 {:a :b}] [1])
    ([err] (= err "Data must be dictionary")))
  "errors on non dictionary data")
(assert
  (try
    (utils/select-keys {1 2 3 4 5 {:a :b}} 1)
    ([err] (= err "Keys must be indexed")))
  "errors on non indexed keys")
