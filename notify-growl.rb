# -*- coding: utf-8 -*-
require 'ruby-growl'
require 'sdl'
Module.new do 
  SDL.init(SDL::INIT_AUDIO)
  SDL::Mixer.open
  plugin = Plugin::create(:notify)
  mdir= DEFAULT_SOUND_DIRECTORY
  g = Growl.new '127.0.0.1',"ruby-growl", ["ruby-growl Notification"]
  # g.register
  str = "mikumiku:"
  notification = "ruby-growl Notification"

  def self.sound(file)
    music = SDL::Mixer::Music.load(file)
    SDL::Mixer.play_music music, 1
  end
  # 取り敢えずメンションがきたら表示するだけ
  plugin.add_event(:mention) do |service, message|
    message.each do |msg|
      user = msg.idname
      g.notify notification, str+"Mention from #{user}", msg.to_show
      sound(mdir + "/message-received.wav")
    end
  end
  #ふぁぼられると通知
  plugin.add_event(:favorite) do |post, user, message|
    f = post.idname 
    u = user.idname 
    m = message.to_show
    g.notify notification, str+"Favorite by #{u}", m unless f == u
    sound(mdir + "/favo.wav")
  end
  #あんふぁぼをされると通知
  plugin.add_event(:unfavorite) do |post, user, message|
    f = post.idname
    u = user.idname
    m = message.to_show
    g.notify notification, str+"Unfavorite by #{u}", m
    sound(mdir + "/favo2.wav")
  end
  #タイムライン更新通知
  plugin.add_event(:update) do |service, message|
    message.each do |msg|
      user = msg.idname
      g.notify notification, str+user, msg.to_show 
      sound(mdir+"/mikutter.wav")
    end
  end
  #ふぉろー通知
  plugin.add_event(:followers_created) do |post, users|
    users.each do |user|
      g.notify notification, str+user.idname, "ふぉろーされました"
    end
  end

  #りむ通知？ 
  # core/addon/notify.rbでは:followers_destroyを利用しているみたい…
  plugin.add_event(:followers_destroy) do |post, users|
    users.each do |user| 
      g.notify notification, str+user.idname, "りむられました"
    end
  end
end
