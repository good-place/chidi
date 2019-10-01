(def- escape-chars 
  {"%20" " " "%3C" "<" "%3E" ">" "%23" `#` "%25" "%"
    "%7B" "{" "%7D" "}" "%7C" "|" "%5C" `\` "%5E" "^"
    "%7E" "~" "%5B" "[" "%5D" "]" "%60" "`" "%3B" ";"
    "%2F" "/" "%3F" "?" "%3A" ":" "%40" "@" "%3D" "="
    "%26" "&" "%24" "$"})

(defn- substitute [patt subst] ~(/ (<- ,patt) ,subst) )

(defn- substitutes [patts]
  (peg/compile ['% ['any ['+ ;patts '(<- 1)]]]))

(def- decode-substitution 
  (substitutes 
    (seq [[patt subst] :pairs escape-chars]
         (substitute patt subst))))

(defn decode
  "Decodes string from query string"
  [s]
  (unless s (break))
  (first (peg/match decode-substitution s)))

(def- encode-substitution 
  (substitutes
    (seq [[subst patt] :pairs escape-chars]
         (substitute patt subst))))

(defn encode
  "Encodes string from query string"
  [s]
  (unless s (break))
  (first (peg/match encode-substitution s)))

(defn get-method 
  "Returns request method as keyword"
  [req]
  (keyword (string/ascii-lower (req :method))))
