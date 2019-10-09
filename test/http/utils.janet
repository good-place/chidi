(import tester :prefix "")
(import chidi/http/utils)

(deftest "decode"
  (test "decode escape chars"
        (= (chidi/http/utils/decode "%20%3C%3E%23%25%7B%7D%7C%5C%5E%7E%5B%5D%60%3B%2F%3F%3A%40%3D%26%24") 
           " <>#%{}|\\^~[]`;/?:@=&$")))

(deftest "encode"
  (test "encode escape chars"
        (= (chidi/http/utils/encode " <>#%{}|\\^~[]`;/?:@=&$") 
           "%20%3C%3E%23%25%7B%7D%7C%5C%5E%7E%5B%5D%60%3B%2F%3F%3A%40%3D%26%24")))

(deftest "get-method"
  (test "gets http method as keyword" 
        (= (chidi/http/utils/get-method {:method "POST"}) :post)))
