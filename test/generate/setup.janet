(import tester :prefix "")
(import temple)

(temple/add-loader)
(import ../../chidi/generate/setup)

(deftest "generating"
  (test "render" (let [b @[]] (with-dyns [:out b] (setup/render :name "test") b))))

