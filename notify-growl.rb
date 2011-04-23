# -*- coding: utf-8 -*-
require 'ruby-growl'
Module.new do 
  plugin = Plugin::create(:notify)
  g = Growl.new '127.0.0.1',"ruby-growl", ["ruby-growl Notification"]
  str = "mikumiku:"
  notification = "ruby-growl Notification"
  # 取り敢えずメンションがきたら表示するだけ
  plugin.add_event(:mention) do |service, message|
    message.each do |msg|
      user = msg.idname
      g.notify notification, str+"Mention from #{user}", msg.to_show
    end
  end
  #ふぁぼられると通知
  plugin.add_event(:favorite) do |post, user, message|
    f = post.idname 
    u = user.idname 
    m = message.to_show
    g.notify notification, str+"Favorite by #{u}", m unless f == u
  end
  #あんふぁぼをされると通知
  plugin.add_event(:unfavorite) do |post, user, message|
    f = post.idname
    u = user.idname
    m = message.to_show
    g.notify notification, str+"Unfavorite by #{u}", m
  end
  #タイムライン更新通知
  plugin.add_event(:update) do |service, message|
    message.each do |msg|
      user = msg.idname
      g.notify notification, str+user, msg.to_show 
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
