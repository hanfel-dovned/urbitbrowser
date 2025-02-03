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
        %rank
      %-  pairs:enjs:format
      :~  [-.upd [%s rank.upd]]
      ==
        %challenge
      %-  pairs:enjs:format
      :~  [-.upd [%s (scot %uv challenge.upd)]]
      ==
        %paths
      %-  pairs:enjs:format
      :~  [%path (path:enjs:format path.upd)]
          [%when (time:enjs:format when.meta.upd)]
          [%score (numb:enjs:format score.meta.upd)]
          [%submitter [%s (scot %p submitter.meta.upd)]]
          [%link [%s link.upd]]
      ==
    ==
++  grad  %noun
--