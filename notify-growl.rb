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
    g.notify "ruby-growl Notification", str+"Favorite by #{user[:idname]}", message.to_show
  end
  #タイムライン更新通知
  plugin.add_event(:update) do |service, message|
    message.each{|msg|
      g.notify "ruby-growl Notification", str+msg.idname, msg.to_show
    }
  end
end
