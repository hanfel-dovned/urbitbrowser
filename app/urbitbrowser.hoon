/-  *urbitbrowser
/+  dbug, default-agent, server, schooner, ethereum, naive
/*  ui  %html  /app/urbitbrowser/html
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
  ==
:: 
++  poke
  |=  =cage
  ^+  that
  ?+    -.cage  !!
      %handle-http-request
    (handle-http !<([@ta =inbound-request:eyre] +.cage))
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
  |=  =path
  ^+  that
  ?:  =('comet' (get-rank get-id))  that
  =.  paths
    (~(put by paths) path [now.bowl ~ 0 get-id])
  ?@  path  !!
  =/  =ship  `@p`(slav %p -.path)
  ?:  =(~ridlyd ship)
    that(links (~(put by links) ~ridlyd 'https://ridlyd.arvo.network/'))
  %-  emit
  :*  %pass  /eauth/(scot %p ship)
      [%keen %.n [ship /e/x/(scot %da now.bowl)//eauth/url]]
  ==
::
::  Count a user's vote.
++  vote
  |=  [=path vote=?]
  ^+  that
  ?:  =('comet' (get-rank get-id))  !!
  =/  old  (~(got by paths) path)
  ?<  (~(has by votes.old) get-id)
  =/  new
    :*  when.old
        (~(put by votes.old) get-id vote)
        ?:(vote (add score.old 1) ?:(=(score.old 0) 0 (sub score.old 1)))
        submitter.old
    ==
  =.  paths
    (~(put by paths) path new)
  that
::
::  Receive a link as a remote scry response.
++  arvo
  |=  [=wire =sign-arvo]
  ^+  that
  ?+    wire  that
      [%eauth @ ~]
    =/  =ship  (slav %p +6:wire)
    ?+    sign-arvo  that 
        [%ames %tune *]
      =/  =roar:ames  (need roar.sign-arvo)
      ::  roar is a [dat=[p=/ q=~] syg=~]    
      =/  c=(cask)  (need q.dat.roar)
      ::  c should be a [%cord *]
      =/  url=@t  (need ;;((unit @t) +.c))
      that(links (~(put by links) ship url))
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
    =/  act  (dejs-action +.json)
    ?-    -.act
        %post
      =.  that  (post path.act)
      (emil (flop (send [200 ~ [%none ~]])))
    ::
        %vote
      =.  that  (vote +.act)
      (emil (flop (send [200 ~ [%none ~]])))
    ::
        %auth
      ?.  (validate +.act)
        !!
      =.  sessions
        (~(put by sessions) [src.bowl who.act])
      %-  emil
      %-  flop
      %-  send
      [200 ~ [%html ui]]
    ==
    ::
      %'GET'
    ::  If this is a new comet, record them.
    ::  If they haven't mask-authed, create a new challenge.
    =?    sessions
        !(~(has by sessions) src.bowl)
      (~(put by sessions) [src.bowl src.bowl])
    =/  new-challenge  (sham [now eny]:bowl)
    =?    challenges
        =(src.bowl (~(got by sessions) src.bowl))
      (~(put in challenges) new-challenge)
    %-  emil  %-  flop  %-  send
    ?+    site  [404 ~ [%plain "404 - Not Found"]]
    ::
        [%urbitbrowser ~]
      [200 ~ [%html ui]]
    ::
        [%urbitbrowser %state ~]
      [200 ~ [%json (enjs-state new-challenge)]]
    ::
        [%urbitbrowser %eauth ~]
      [302 ~ [%login-redirect '/urbitbrowser&eauth']] 
    ==
  ==
::
++  enjs-state
  |=  challenge=secret
  ^-  json
  %-  pairs:enjs:format
  :~  [%rank [%s (get-rank get-id)]]
      [%challenge [%s (scot %uv challenge)]]
      :-  %paths
      :-  %a
      %+  turn
        ~(tap by paths)
      |=  [=path when=@da votes=(map ship ?) score=@ud submitter=ship]
      %-  pairs:enjs:format
      :~  [%path (path:enjs:format path)]
          [%when (time:enjs:format when)]
          [%score (numb:enjs:format score)]
          [%submitter [%s (scot %p submitter)]]
      ::
          ?@  path  !!
          =/  =ship  `@p`(slav %p -.path)
          [%link [%s (~(gut by links) ship 'https://urbit.org')]]
      ==
  ==
::
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  action
  %.  jon
  %-  of
  :~  [%post (ot ~[path+pa])]
      [%vote (ot ~[path+pa vote+bo])]
      [%auth (ot ~[who+(se %p) secret+(se %uv) address+sa signature+sa])]
  ==
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
--
