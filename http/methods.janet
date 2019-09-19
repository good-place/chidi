(import http/utils :as hu)
(import http/response :as hr)

(defn guards
  "Middleware for quarding only some http methods"
  [nextmw & methods]
  (fn [req] 
    (let [method (hu/get-method req)]
      (if (some |(= method $) methods)
        (nextmw req)
        (hr/method-not-allowed 
          {:message (string/join ["Method '" method
                                  "' is not supported. Please use " 
                                  (string/join methods " or ") ])})))))
