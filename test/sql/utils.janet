(import tester :prefix "")
(import ../../chidi/sql/utils)

(def tbl "chidi-test.db")

(deftest "open"
  (test "opens db and sets it"
        (do
          (utils/open tbl)
          (not (nil? utils/db))))) # @todo get current test file

(deftest "close"
  (test "closes db"
        (do
          (utils/open tbl)
          (nil? (utils/close)))))

(deftest "drop-table"
  (test "drops table if exists"
        (do
          (utils/open tbl)
          (utils/drop-table :people))))

(deftest "create-table"
  (test "creates table"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})))
  (test "does not create table without columns"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (try
            (utils/create-table :people {})
            ([err] (= err "Cannot create table without columns"))))))

(deftest "insert"
  (test "inserts record"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/insert :people {:name "pepe"})))
  (test "does not insert empty record"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (try
            (utils/insert :people {})
            ([err] (= "Cannot insert empty record" err))))))

(deftest "get-records"
  (test "get all records"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/insert :people {:name "pepe"})
          (deep= (utils/get-records :people) @[{:id 1 :name "pepe"}]))))

(deftest "get-record"
  (test "get record by id"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/insert :people {:name "pepe"})
          (= (utils/get-record :people 1) {:id 1 :name "pepe"}))))

(deftest "find-records"
  (test "find records by query"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/insert :people {:name "pepe"})
          (deep= (utils/find-records :people {:name "pepe"}) @[{:id 1 :name "pepe"}]))))

(deftest "update"
  (test "updates record"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/insert :people {:name "pepe"})
          (utils/update :people 1 {:name "Pepe"})
          (deep= (utils/get-record :people 1) {:id 1 :name "Pepe"})))
  (test "does not update record with empty record"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/insert :people {:name "pepe"})
          (try
            (utils/update :people 1 {})
            ([err] (= "Cannot update with empty record"))))))

(deftest "delete"
  (test "deletes record"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/insert :people {:name "pepe"})
          (utils/delete :people 1)
          (nil? (utils/get-record :people 1)))))

(deftest "transaction"
  (test "creates transaction"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (utils/begin-transaction)
          (utils/insert :people {:name "pepe"})
          (utils/end-transaction)
          (deep= (utils/find-records :people {:name "pepe"}) @[{:id 1 :name "pepe"}])))
  (test "cannot end non started transaction"
        (do
          (utils/open tbl)
          (utils/drop-table :people)
          (utils/create-table :people {:name :TEXT})
          (try (utils/end-transaction)
               ([err] (= "err cannot commit - no transaction is active"))))))

(utils/close)

