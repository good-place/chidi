(import tester :prefix "")
(import chidi/sql/utils)

(def tbl "chidi-test.db")

(deftest "open"
  (test "opens db and sets it" 
        (do 
          (chidi/sql/utils/open tbl)
          (not (nil? chidi/sql/utils/db))))) # @todo get current test file

(deftest "close"
  (test "closes db" 
        (do 
          (chidi/sql/utils/open tbl)
          (nil? (chidi/sql/utils/close)))))

(deftest "drop-table"
  (test "drops table if exists"
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people))))
          
(deftest "create-table"
  (test "creates table"
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})))
  (test "does not create table without columns"
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (try 
            (chidi/sql/utils/create-table :people {})
            ([err] (= err "Cannot create table without columns"))))))

(deftest "insert"
  (test "inserts record" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/insert :people {:name "pepe"})))
  (test "does not insert empty record"
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (try 
            (chidi/sql/utils/insert :people {})
            ([err] (= "Cannot insert empty record" err))))))

(deftest "get-records"
  (test "get all records" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/insert :people {:name "pepe"})
          (deep= (chidi/sql/utils/get-records :people) @[{"id" 1 "name" "pepe"}]))))

(deftest "get-record"
  (test "get record by id" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/insert :people {:name "pepe"})
          (= (chidi/sql/utils/get-record :people 1) {"id" 1 "name" "pepe"}))))

(deftest "find-records"
  (test "find records by query" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/insert :people {:name "pepe"})
          (deep= (chidi/sql/utils/find-records :people {:name "pepe"}) @[{"id" 1 "name" "pepe"}]))))

(deftest "update"
  (test "updates record" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/insert :people {:name "pepe"})
          (chidi/sql/utils/update :people 1 {:name "Pepe"})
          (deep= (chidi/sql/utils/get-record :people 1) {"id" 1 "name" "Pepe"})))
  (test "does not update record with empty record" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/insert :people {:name "pepe"})
          (try 
            (chidi/sql/utils/update :people 1 {})
            ([err] (= "Cannot update with empty record"))))))

(deftest "delete"
  (test "deletes record" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/insert :people {:name "pepe"})
          (chidi/sql/utils/delete :people 1)
          (nil? (chidi/sql/utils/get-record :people 1)))))

(deftest "transaction"
  (test "creates transaction" 
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (chidi/sql/utils/begin-transaction)
          (chidi/sql/utils/insert :people {:name "pepe"})
          (chidi/sql/utils/end-transaction)
          (deep= (chidi/sql/utils/find-records :people {:name "pepe"}) @[{"id" 1 "name" "pepe"}])))
  (test "cannot end non started transaction"
        (do 
          (chidi/sql/utils/open tbl)
          (chidi/sql/utils/drop-table :people)
          (chidi/sql/utils/create-table :people {:name :TEXT})
          (try (chidi/sql/utils/end-transaction)
               ([err] (= "err cannot commit - no transaction is active"))))))

(chidi/sql/utils/close)

