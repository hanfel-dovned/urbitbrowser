/-  *urbitbrowser
|_  upd=update
++  grab
  |%
  ++  noun  update
  --
++  grow
  |%
  ++  noun  upd
  ++  json  
    ?-  -.upd
        %path
      =/  =meta  +14.upd
      %-  pairs:enjs:format
      :~  [%path (path:enjs:format path.upd)]
          [%when (time:enjs:format when.meta)]
          [%score (numb:enjs:format score.meta)]
          [%submitter [%s (scot %p submitter.meta)]]
          [%link [%s +15.upd]]
          [%tags [%a (turn tags.meta |=(=cord [%s cord]))]]
          :-  %comments
          :-  %a
          %+  turn  comments.meta
          |=  =comment
            ~&  comment
            %-  pairs:enjs:format
            :~  [%who [%s (scot %p who.comment)]]
                [%when (time:enjs:format when.comment)]
                [%what [%s what.comment]]
            ==
      ==
      ::
        %post
      =/  =meta  +.upd
      %-  pairs:enjs:format
      :~  [%when (time:enjs:format when.meta)]
          [%score (numb:enjs:format score.meta)]
          [%submitter [%s (scot %p submitter.meta)]]
          [%tags [%a (turn tags.meta |=(=cord [%s cord]))]]
          :-  %comments
          :-  %a
          %+  turn  comments.meta
          |=  =comment
            %-  pairs:enjs:format
            :~  [%who [%s (scot %p who.comment)]]
                [%when (time:enjs:format when.comment)]
                [%what [%s what.comment]]
            ==
      ==
    ==
  --
++  grad  %noun
--