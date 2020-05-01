(declare-project
  :name "chidi"
  :description "A framework for real-time applications and REST APIs"
  :dependencies ["https://github.com/janet-lang/circlet.git"
                 "https://github.com/pepe/argparse.git"
                 "https://github.com/janet-lang/json.git"
                 "https://github.com/janet-lang/path.git"
                 "https://github.com/pepe/trolley.git"
                 "https://github.com/joy-framework/tester"
                 "https://git.sr.ht/~bakpakin/temple"
                 "https://github.com/andrewchambers/janet-uri.git"
                 "https://github.com/good-place/mansion.git"])

(declare-source :source ["chidi"])

(declare-binscript :main "chd")
