(declare-project
  :name "chidi"
  :description "A framework for real-time applications and REST APIs"
  :dependencies ["https://github.com/janet-lang/circlet.git"
                 "https://github.com/bakpakin/jurl.git" 
                 "https://github.com/janet-lang/sqlite3.git"
                 "https://github.com/janet-lang/json.git"
                 "https://github.com/joy-framework/tester"])

(declare-executable
  :name "chidi"
  :entry "server.janet")
