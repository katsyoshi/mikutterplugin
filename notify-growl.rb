# -*- coding: utf-8 -*-
require 'ruby-growl'
Module.new do 
  plugin = Plugin::create(:notify)
  g = Growl.new '127.0.0.1',"ruby-growl", ["ruby-growl Notification"]
  str = "mikumiku:"
  # 取り敢えずメンションがきたら表示するだけ
  plugin.add_event(:mention) do |service, message|
    message.each{ |msg|
      user = msg.idname
      g.notify "ruby-growl Notification", str+"Mention from #{user}", msg.to_show
    }
  end
  #ふぁぼられると通知
  plugin.add_event(:favorite) do |post, user, message|
    u = message.idname
    g.notify "ruby-growl Notification", str+"Favorite by #{u}", message.to_show
  end
  #タイムライン更新通知
  plugin.add_event(:update) do |service, message|
    message.each{|msg|
      user = msg.idname
      g.notify "ruby-growl Notification", str+user, msg.to_show 
    }
  end
  #ふぉろー通知
  plugin.add_event(:followers_created) do |post, users|
    users.each do |user|
      g.notify "ruby-growl Notification", str+user.idname, "ふぉろーされました"
    end
  end

  #りむ通知？ 
  # core/addon/notify.rbでは:followers_destroyを利用しているみたい…
  plugin.add_event(:followers_destroy) do |post, users|
    users.each do |user| 
      g.notify "ruby-growl Notification", str+user.idname, "りむられました"
    end
  end
end
