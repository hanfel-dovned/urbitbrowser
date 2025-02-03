|%
+$  paths  (map path meta)
+$  meta
  $:  when=@da
      votes=(map ship ?)
      score=@ud
      submitter=ship
      tags=(list @t)
  ==
+$  secret  @uv
+$  challenges  (set secret)
+$  sessions  (map comet=@p id=@p)
+$  action  
  $%  
      [%post =path tags=(list @t)]
      [%vote =path vote=?]
      [%auth who=@p =secret address=tape signature=tape]
  ==
+$  update 
  $%  [%rank =cord]
      [%challenge challenge=@uv]
      [%path =path =meta link=cord]
  ==
--