(defn- assert-dictionary [data]
  (unless (dictionary? data) (error "Data must be dictionary")))

(defn- assert-indexed [data]
  (unless (indexed? data) (error "Data must be indexed")))

(defn map-keys 
  "Returns new struct with f applied to dictionary's keys"
  [f data]
  (assert-dictionary data)
  (-> (seq [[k v] :pairs data] [(f k) v])
       flatten
       splice
       table
       freeze))

(defn map-vals
  "Returns new struct with f applied to dictionary's values"
  [f data]
  (assert-dictionary data)
  (-> (seq [[k v] :pairs data] [k (f v)])
       flatten
       splice
       table
       freeze))

(defn select-keys 
  "Returns new struct with selected keys from dictionary"
  [data keyz]
  (assert-dictionary data) (assert-indexed keyz)
  (def res @{})
  (loop [[k v] :pairs data :when (some |(= k $) keyz)] (put res k v))
  (freeze res))
