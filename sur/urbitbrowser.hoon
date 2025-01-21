|%
+$  paths  (map path meta)
+$  meta
  $:  when=@da
      votes=(map ship ?)
      score=@ud
      submitter=ship
  ==
+$  secret  @uv
+$  challenges  (set secret)
+$  sessions  (map comet=@p id=@p)
+$  action  
  $%  [%post =path]
      [%vote =path vote=?]
      [%auth who=@p =secret address=tape signature=tape]
  ==
--