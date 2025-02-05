|%
+$  paths  (map path meta)
+$  meta
  $:  when=@da
      votes=(map ship ?)
      score=@ud
      submitter=ship
      body=@t
      tags=(list @t)
      comments=(list comment)
  ==
+$  comment
  $:  who=ship
      when=@da
      what=@t
  ==
+$  secret  @uv
+$  challenges  (set secret)
+$  sessions  (map comet=@p id=@p)
+$  action  
  $%  
      [%post =path body=@t tags=(list @t)]
      [%vote =path vote=?]
      [%comment =path text=@t]
      [%auth who=@p =secret address=tape signature=tape]
  ==
+$  update 
  $%  
      [%path =path =meta link=@t]
      [%post link=@t =meta]
  ==
--