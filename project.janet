(declare-project
  :name "chidi"
  :description "A framework for real-time applications and REST APIs"
  :dependencies ["https://github.com/janet-lang/circlet.git"
                 "https://github.com/janet-lang/sqlite3.git"
                 {:repo "https://github.com/pepe/jurl.git" :tag "994b835d3bfdf7b8e81aa28697cf1c51d61344cb"} 
                 "https://github.com/pepe/argparse.git"
                 "https://github.com/janet-lang/json.git"
                 "https://github.com/janet-lang/path.git"
                 "https://github.com/pepe/trolley.git"
                 "https://github.com/joy-framework/tester"])

(declare-source :source ["chidi"])

(declare-binscript :main "chd")
