(comment (import tester :prefix "")
         (import ../chidi/service)
         (import mansion/store :as ms)

         (deftest "defservice macro"
           (test "expands"
                 (= (macex1 '(service/defservice :people))
                    ~(tuple (def name :people) (def store (,ms/open "people")))))))

# @todo how to test this?
# (deftest "many macro"
# (pp (macex1 '(chidi/service/many :get)))
# (test "expands"
# (= (macex1 '(chidi/service/many :get))
# '(defn many [req] (let [{:body body :query-params qp :method method} req] (case method "GET" (let [records (if qp (<function find-records> sqt (allowed-keys qp)) (<function get-records> sqt))] (<function success> records)) "POST" (<function method-not-allowed> {:message "Method POST is not allowed"})))))))

