/-  *urbitbrowser
|%
++  enjs-update 
  |=  upd=update
  ^-  json
  ?-  -.upd
      %path  (enjs-path +.upd)
      %post  (enjs-path ~ +.+.upd -.+.upd)
    ==
++  enjs-path
  |=  [=path =meta link=cord]
  ^-  json
  =,  meta
  %-  pairs:enjs:format
  :~  ?:  =(path ~)  [%path ~]
      [%path (path:enjs:format path)]
      [%when (time:enjs:format when)]
      [%votes [%a (enjs-votes votes)]]
      [%score (numb:enjs:format score)]
      [%submitter [%s (scot %p submitter)]]
      [%body [%s body]]
      [%tags [%a (turn tags |=(=cord [%s cord]))]]
      [%comments [%a (enjs-comments comments)]]
      [%link [%s link]]
  ==
++  enjs-votes
  |=  votes=(map ship ?)
  %+  turn
    ~(tap by votes)
  |=  [=ship vote=?]
  %-  pairs:enjs:format
  :~  [%ship [%s (scot %p ship)]]
      [%vote [%b vote]] 
  ==
++  enjs-comments
  |=  comments=(list comment)
  %+  turn  comments
  |=  comment=[who=@p when=@da what=@t]
  ^-  json
  %-  pairs:enjs:format
  :~  [%who [%s (scot %p who.comment)]]
      [%when (time:enjs:format when.comment)]
      [%what [%s what.comment]]
  ==
--
