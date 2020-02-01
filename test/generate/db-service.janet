(import tester :prefix "")
(import temple)

(temple/add-loader)
(import ../../chidi/generate/db-service)

(deftest "generating"
  (test "render" (let [b @[]] (with-dyns [:out b] (db-service/render :name "test") b))))
