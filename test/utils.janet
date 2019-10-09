(import tester :prefix "")
(import chidi/utils)

(deftest "map-keys"
  (test "returns keys mapped with function" 
        (= (chidi/utils/map-keys string {1 2 3 4}) {"1" 2 "3" 4}))
  (test "returns keys mapped with function in nested struct" 
        (= (chidi/utils/map-keys string {1 2 3 {:a :b}}) {"1" 2 "3" {:a :b}}))
  (test "errors on non dictionary data" 
        (try 
          (chidi/utils/map-keys string [1 2 3 {:a :b}])
          ([err] (= err "Data must be dictionary")))))

(deftest "map-vals"
  (test "returns values mapped with function" 
        (= (chidi/utils/map-vals string {1 2 3 4}) {1 "2" 3 "4"}))
  (test "returns values mapped with function in nested struct" 
        (= (chidi/utils/map-vals type {1 2 3 {:a :b}}) {1 :number 3 :struct}))
  (test "errors on non dictionary data" 
        (try 
          (chidi/utils/map-vals string [1 2 3 {:a :b}])
          ([err] (= err "Data must be dictionary")))) )

(deftest "select-keys"
  (test "selects keys from dictionary" 
        (= (chidi/utils/select-keys {1 2 3 4 5 6} [1 5]) {1 2 5 6}))
  (test "selects key from dictionary" 
        (= (chidi/utils/select-keys {1 2 3 4 5 6} [1]) {1 2}))
  (test "selects keys from nested dictionary" 
        (= (chidi/utils/select-keys {1 2 3 4 5 {:a :b}} [1 5]) {1 2 5 {:a :b}}))
  (test "errors on non dictionary data" 
        (try 
          (chidi/utils/select-keys [1 2 3 {:a :b}] [1])
          ([err] (= err "Data must be dictionary"))))
  (test "errors on non indexed keys" 
        (try 
          (chidi/utils/select-keys [1 2 3 {:a :b}] 1)
          ([err] (= err "Data must be dictionary")))) )
