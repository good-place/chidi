(defn content [name]
  (string 
``(declare-project
  :name "`` name ``"
  :description "Really great API" # @fixme with some real desc here please
  :dependencies ["https://github.com/pepe/chidi.git"])``))

