(import tester :prefix "")
(import ../chidi/utils)

(deftest "map-keys"
  (test "returns keys mapped with function"
        (= (utils/map-keys string {1 2 3 4}) {"1" 2 "3" 4}))
  (test "returns keys mapped with function in nested struct"
        (= (utils/map-keys string {1 2 3 {:a :b :c {:d 3}}})
           {"1" 2 "3" {"a" :b "c" {"d" 3}}}))
  (test "errors on non dictionary data"
        (try
          (utils/map-keys string [1 2 3 {:a :b}])
          ([err] (= err "Data must be dictionary")))))

(deftest "map-vals"
  (test "returns values mapped with function"
        (= (utils/map-vals string {1 2 3 4}) {1 "2" 3 "4"}))
  (test "returns values mapped with function in nested struct"
        (= (utils/map-vals type {1 2 3 {:a :b}}) {1 :number 3 :struct}))
  (test "errors on non dictionary data"
        (try
          (utils/map-vals string [1 2 3 {:a :b}])
          ([err] (= err "Data must be dictionary")))) )

(deftest "select-keys"
  (test "selects keys from dictionary"
        (= (utils/select-keys {1 2 3 4 5 6} [1 5]) {1 2 5 6}))
  (test "selects key from dictionary"
        (= (utils/select-keys {1 2 3 4 5 6} [1]) {1 2}))
  (test "selects keys from nested dictionary"
        (= (utils/select-keys {1 2 3 4 5 {:a :b}} [1 5]) {1 2 5 {:a :b}}))
  (test "errors on non dictionary data"
        (try
          (utils/select-keys [1 2 3 {:a :b}] [1])
          ([err] (= err "Data must be dictionary"))))
  (test "errors on non indexed keys"
        (try
          (utils/select-keys {1 2 3 4 5 {:a :b}} 1)
          ([err] (= err "Keys must be indexed")))))
