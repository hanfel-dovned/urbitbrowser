/-  *urbitbrowser
/+  dbug, default-agent, server, schooner, ethereum, naive
/*  ui  %html  /app/urbitbrowser/html
/*  ui-post  %html  /app/post/html
/*  css  %css  /app/style/css
::
|%
+$  versioned-state  $%(state-0)
+$  state-0  
  $:  %0 
      =paths
      links=(map ship link=@t)
      =sessions
      =challenges
  ==
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
::
=<
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
    hc   ~(. +> [bowl ~])
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state  abet:init:hc
  [cards this]
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =^  cards  state  abet:(load:hc vase)
  [cards this]
::
++  on-poke
  |=  =cage
  ^-  (quip card _this)
  =^  cards  state  abet:(poke:hc cage)
  [cards this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  [~ ~]
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  `this
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  =^  cards  state  abet:(arvo:hc [wire sign-arvo])
  [cards this]
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  =^  cards  state  abet:(watch:hc path)
  [cards this]
::
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
::
|_  [=bowl:gall deck=(list card)]
+*  that  .
::
++  emit  |=(=card that(deck [card deck]))
++  emil  |=(lac=(list card) that(deck (welp lac deck)))
++  abet  ^-((quip card _state) [(flop deck) state])
::
++  init 
  ^+  that
  %-  emit
  :*  %pass   /eyre/connect   
      %arvo  %e  %connect
      `/urbitbrowser  %urbitbrowser
  ==
::
++  load
  |=  =vase
  ^+  that
  =/  old  !<(versioned-state vase)
  ?-  -.old
    %0  that(state old)
  ==
::
++  watch
  |=  =path
  ^+  that
  ?+    path  that
      [%http-response *]
    that
    ::
      [%paths ~]
    that
    ::
      [%post *]
    =/  post-path  +:path
    ~&  >  post-path 
    ?~  (~(get by paths) post-path)  
    ~&  >>>  %kick
      %-  emit
      [%give %kick ~[(welp /post post-path)] ~]
    =/  =meta  (~(got by paths) post-path)
    =/  link  (get-url post-path)
    ~&   >  meta
    %-  emit
    [%give %fact ~[(welp /post post-path)] %ub-update !>(`update`[%post link meta])]
  ==
:: 
++  poke
  |=  [=mark =vase]
  ^+  that
  ?+  mark  !!
      %handle-http-request
    (handle-http !<([@ta =inbound-request:eyre] vase))
  ==
::
::  If eauthed in, use that. 
::  Else, check for mask auth. 
++  get-id
  ^-  @p
  ?:  ?!(=('comet' (get-rank src.bowl)))
    src.bowl
  =/  authed  (~(got by sessions) src.bowl)
  ?:  ?!(=('comet' (get-rank authed)))
    authed
  src.bowl
::
::  Add a new path and remote scry the owner's URL.
++  post
  |=  [=path body=cord tags=(list @t) eyre-id=@ta]
  ^+  that
  =+  send=(cury response:schooner eyre-id)
  ?:  =('comet' (get-rank get-id))  
    %-  emil 
    %-  flop  %-  send
    response-403 
  :: if path alredy been shared send message back 
  ~&  >>>   (~(get by paths) path)
  ?.  =((~(get by paths) path) ~)
    ~&  >>>  "{(spud path)} already been published"
    %-  emil
    %-  flop  %-  send
    [206 ~ [%plain "{(spud path)} already been published"]]
  ::  ???
  ?@  path  !!
  ::
  ?~  (slaw %p -.path)
    %-  emil
    %-  flop  %-  send
    [400 ~ [%plain "{(spud path)} expected to start with valid @p"]]
  ::
  =/  =meta  [now.bowl ~ 0 get-id body tags ~]
  =.  paths
    (~(put by paths) path meta)
  =/  =ship  `@p`(slav %p -.path)
  ?~  (~(get by links) ship)
    ::  sending request to eauth to get valid url for ship
    %-  emil
    %+  welp 
      %-  flop  %-  send
      (ok-post-response path)
    :~
      :*  %pass  (welp /eauth/(scot %p ship) path)
          [%keen %.n [ship /e/x/(scot %da now.bowl)//eauth/url]]
      ==
    ==
  =/  url  (get-url path)
  %-  emil
  %+  welp 
    %-  flop  %-  send
    (ok-post-response path)
  ~[(update-card path meta url)]
  ::  For now, remove from production
  :: ?:  =(ship our.bowl)  
  ::   =.  links  (~(put by links) ship 'http://localhost:8080')
  ::   %-  emil
  ::   %+  welp 
  ::     %-  flop  %-  send
  ::     (ok-post-response path)
  ::   ~[(update-card path meta (get-url path))]
::
::  Count a user's vote.
++  vote
  |=  [=path vote=? eyre-id=@ta]
  ^+  that
  =+  send=(cury response:schooner eyre-id)
  ?:  =('comet' (get-rank get-id))  
    %-  emil 
    %-  flop  %-  send
    response-403 
  =/  link=cord  (get-url path)
  =+  response=(flop (send ok-vote-response))
  ::  sending updated vote count to subscriber
  =/  meta  (~(got by paths) path)
  ?:  (~(has by votes.meta) get-id)
    =/  old-vote  (~(got by votes.meta) get-id)
    ::  if old vote and new vote are matching remove vote
    ?:  =(vote old-vote)  
      =:  votes.meta  (~(del by votes.meta) get-id)
          score.meta  
            ?:  vote 
              (sub score.meta 1)
            ?:  =(score.meta 0)  0
            (add score.meta 1)
      ==
      =.  paths
        (~(put by paths) path meta)
    %-  emil
    %+  welp 
      response
    ~[(update-card path meta link)]
    ::  if oldVote is %.y and new is %.n
    ::  overwrite vote and score -2
    ::  if oldVote is %.n and new is %.y
    ::  overwrite vote and score +2
    ~&  %changing-vote
    =:  votes.meta  (~(put by votes.meta) get-id vote)
        score.meta 
          ?:  vote 
            ?:  =(score.meta 0)  1
            (add score.meta 2)
          ?.  (gth score.meta 2)  0
          (sub score.meta 2)
    ==
    =.  paths
      (~(put by paths) path meta)
    %-  emil
    %+  welp 
      response
    ~[(update-card path meta link)]
  =:  votes.meta  (~(put by votes.meta) get-id vote)
      score.meta  
        ?:  vote  (add score.meta 1) 
        ?:  =(score.meta 0)  0 
        (sub score.meta 1)
  ==
  =.  paths
    (~(put by paths) path meta)
  %-  emil
    %+  welp 
      response
  ~[(update-card path meta link)]
::
++  create-comment
  |=  [=path text=@t eyre-id=@ta]
  ^+  that 
  =+  send=(cury response:schooner eyre-id)
  ?:  =('commet' (get-rank get-id))  
    %-  emil 
    %-  flop  %-  send
    response-403 
  =/  link=cord  (get-url path)
  =/  meta  (~(get by paths) path)
  ?~  meta  that  
  =.  comments.u.meta  
    %+  snoc  comments.u.meta 
    [src.bowl now.bowl text]
  =.  paths
    (~(put by paths) path u.meta)
  %-  emil 
  %+  welp 
    %-  flop  %-  send 
    [200 ~ [%plain "comment action was successful"]]
  :~
    [%give %fact ~[(welp /post path)] %ub-update !>(`update`[%post (get-url path) u.meta])]
  ==
::
::  Receive a link as a remote scry response.
++  arvo
  |=  [=wire =sign-arvo]
  ^+  that
  ?+    wire  that
      [%eauth @ *]
    ~&  >  'got response from remote scry'
    =/  =ship  (slav %p +6:wire)
    =/  path  +7:wire
    ?+    sign-arvo  that 
        [%ames %tune *]
      =/  =roar:ames  (need roar.sign-arvo)
      ::  roar is a [dat=[p=/ q=~] syg=~]    
      =/  c=(cask)  (need q.dat.roar)
      ::  c should be a [%cord *]
      =/  eauth-url=@t  (need ;;((unit @t) +.c))
      ::  removing appended /~/eauth from host url
      =/  url=@t  
        %-  crip
        %-  flop  
        %+  oust  [0 8] 
        %-  flop  (trip eauth-url)
      =.  links  (~(put by links) ship url)
      %-  emit 
      %:  update-card 
        path 
        (~(got by paths) path) 
        url
      ==
    ==
  ==
::
++  handle-http
  |=  [eyre-id=@ta =inbound-request:eyre]
  ^+  that
  =/  ,request-line:server
    (parse-request-line:server url.request.inbound-request)
  =+  send=(cury response:schooner eyre-id)
  ::
  ?+    method.request.inbound-request
    (emil (flop (send [405 ~ [%stock ~]])))
    ::
      %'POST'
    ?~  body.request.inbound-request  !!
    =/  json  (de:json:html q.u.body.request.inbound-request)
    =/  act=action  (dejs-action +.json)
    ?-    -.act
        %post
      (post path.act body.act tags.act eyre-id)
    ::
        %vote
      ~&  (~(get by (malt header-list.request.inbound-request)) 'referer')
      (vote path.act vote.act eyre-id)
    ::
        %comment
      (create-comment path.act text.act eyre-id)
    ::
        %auth
      ?.  (validate +.act)
        !!
      =.  sessions
        (~(put by sessions) [src.bowl who.act])
      ~&  >  :-  src.bowl  'authenticated'
      that
    ==
    ::
      %'GET'
    ::  If this is a new comet, record them.
    ::  If they haven't mask-authed, create a new challenge.
    =?    sessions
        !(~(has by sessions) src.bowl)
      (~(put by sessions) [src.bowl src.bowl])
    =/  new-challenge  (sham [now eny]:bowl)
    =?  challenges
        =(src.bowl (~(got by sessions) src.bowl))
      (~(put in challenges) new-challenge)
    ~&  >>  site
    ?+    site  
      %-  emil  %-  flop  %-  send
      [404 ~ [%plain "404 - Not Found"]]
    ::
        [%urbitbrowser ~]
      %-  emil  %-  flop  %-  send
      [200 ~ [%html ui]]
    ::
        [%urbitbrowser %style ~]
      %-  emil  %-  flop
      %+  give-simple-payload:app:server
        eyre-id
      :-  :-  200  ['content-type'^'text/css']~
      `(as-octs:mimes:html css)
    ::
        [%urbitbrowser %state ~]
      %-  emil  %-  flop  %-  send
      [200 ~ [%json (enjs-state new-challenge)]]
    ::
        [%urbitbrowser %eauth ~]
      %-  emil  %-  flop  %-  send
      [302 ~ [%login-redirect '/urbitbrowser&eauth']] 
    ::
        [%urbitbrowser %post *]
      =/  path  ;;(path +7:site)
      =/  in-paths  (~(get by paths) path)
      %-  emil  %-  flop  %-  send
      ?~  in-paths  [200 ~ [%redirect '/urbitbrowser']]
      [200 ~ [%html ui-post]]
    ==
  ==
::
++  enjs-state
  |=  challenge=secret
  ^-  json
  %-  pairs:enjs:format
  :~  [%rank [%s (get-rank get-id)]]
      [%challenge [%s (scot %uv challenge)]]
      [%patp [%s (scot %p get-id)]]
      :-  %paths
      :-  %a
      %+  turn
        ~(tap by paths)
      |=  [=path when=@da votes=(map ship ?) score=@ud submitter=ship body=@t tags=(list @t) comments=(list comment)]
      =/  json-votes
        %+  turn
        ~(tap by votes)
        |=  [=ship vote=?]
        %-  pairs:enjs:format
        :~  [%ship [%s (scot %p ship)]]
            [%vote [%b vote]] 
        ==
      %-  pairs:enjs:format
      :~  [%path (path:enjs:format path)]
          [%when (time:enjs:format when)]
          [%votes [%a json-votes]]
          [%score (numb:enjs:format score)]
          [%submitter [%s (scot %p submitter)]]
          [%body [%s body]]
          [%tags [%a (turn tags |=(=cord [%s cord]))]]
          [%comments [%a (turn comments comment-to-obj)]]
      ::
          :: ?@  path  !!
          [%link [%s (get-url path)]]
      ==
  ==
::
++  comment-to-obj
  |=  comment=[who=@p when=@da what=@t]
  ^-  json
  %-  pairs:enjs:format
  :~  [%who [%s (scot %p who.comment)]]
      [%when (time:enjs:format when.comment)]
      [%what [%s what.comment]]
  ==
::
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  action
  %.  jon
  %-  of
  :~  
      [%post (ot ~[path+pa body+so tags+(ar so)])]
      [%vote (ot ~[path+pa vote+bo])]
      [%comment (ot ~[path+pa text+so])]
      [%auth (ot ~[who+(se %p) secret+(se %uv) address+sa signature+sa])]
  ==
::
++  get-url 
  |=  =path
  ^-  cord
  =/  ship  `@p`(slav %p -.path)
  =/  url  (~(gut by links) ship 'https://urbit.org')
  ?:  =(url 'https://urbit.org')  url
  %-  crip  %+  welp 
    %-  trip  
    url  
  (spud +.path)
  :: (oust [0 1] path)
::
++  get-rank
  |=  who=@p
  ^-  @t
  ?:  (gth who 0xffff.ffff)
    'comet'
  ?:  (gth who 0xffff)
    'planet'
  ?:  (gth who 0xff)
    'star'
  'galaxy'
::
::  Modified from ~rabsef-bicrym's %mask
::  Validate that Owner of Who = Signer of Challenge
++  validate
  |=  [who=@p challenge=secret address=tape hancock=tape]
  ^-  ?
  =/  addy  (from-tape address)
  =/  cock  (from-tape hancock)
  =/  owner  (get-owner who)
  ?~  owner  %.n
  ::  .^(? %j /=fake=)  :: XX not sure this makes sense for signing into someone else's ship
  ?.  =(addy u.owner)  %.n
  ?.  (~(has in challenges) challenge)  %.n
  =/  note=@uvI
    =+  octs=(as-octs:mimes:html (scot %uv challenge))
    %-  keccak-256:keccak:crypto
    %-  as-octs:mimes:html
    ;:  (cury cat 3)
      '\19Ethereum Signed Message:\0a'
      (crip (a-co:co p.octs))
      q.octs
    ==
  ?.  &(=(20 (met 3 addy)) =(65 (met 3 cock)))  %.n
  =/  r  (cut 3 [33 32] cock)
  =/  s  (cut 3 [1 32] cock)
  =/  v=@
    =+  v=(cut 3 [0 1] cock)
    ?+  v  !!
      %0   0
      %1   1
      %27  0
      %28  1
    ==
  ?.  |(=(0 v) =(1 v))  %.n
  =/  xy
    (ecdsa-raw-recover:secp256k1:secp:crypto note v r s)
  =/  pub  :((cury cat 3) y.xy x.xy 0x4)
  =/  add  (address-from-pub:key:ethereum pub)
  =(addy add)
::
++  from-tape
  |=(h=tape ^-(@ux (scan h ;~(pfix (jest '0x') hex))))
::
++  get-owner
  |=  who=@p
  ^-  (unit @ux)
  =-  ?~  pin=`(unit point:naive)`-
        ~
      ?.  |(?=(%l1 dominion.u.pin) ?=(%l2 dominion.u.pin))
        ~
      `address.owner.own.u.pin
  .^  (unit point:naive)
    %gx
    /(scot %p our.bowl)/azimuth/(scot %da now.bowl)/point/(scot %p who)/noun
  ==
::
++  update-card 
  |=  [=path =meta link=cord]
  ^-  card 
  ~&  >>>  `update`[%path path meta link]
  [%give %fact ~[/paths] %ub-update !>(`update`[%path path meta link])]
::
++  ok-post-response
  |=  =path
  [200 ~ [%plain "Publish {(spud path)} action was successful"]]
::
++  ok-vote-response
  [200 ~ [%plain "Vote action was successful"]]
::
++  response-403 
  [403 ~ [%plain "Not authorized: You do not have permission to perform this request."]]
--
