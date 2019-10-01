(defn map-keys 
  "Returns new struct with f applied to dictionary's keys"
  [f d]
  (-> [[k v] :pairs d]
       (seq [(f k) v])
       flatten
       splice
       table
       freeze))

(defn map-vals
  "Returns new struct with f applied to dictionary's values"
  [f d]
  (-> [[k v] :pairs d]
       (seq [k (f v)])
       flatten
       splice
       table
       freeze))

(defn select-keys 
  "Returns new struct with selected keys from dictionary"
  [dictionary keyz]
  (def res @{})
  (loop [[k v] :pairs dictionary]
    (when (some |(= k $) keyz) (put res k v)))
  (freeze res))
