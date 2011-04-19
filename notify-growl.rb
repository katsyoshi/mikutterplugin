# -*- coding: utf-8 -*-
require 'ruby-growl'
Module.new do 
  plugin = Plugin::create(:notify)
  g = Growl.new '127.0.0.1',"ruby-growl", ["ruby-growl Notification"]
  str = "mikumiku:"
  # 取り敢えずメンションがきたら表示するだけ
  plugin.add_event(:mention) do |service, message|
    message.each{ |msg|
      g.notify "ruby-growl Notification", str+"Mention", msg.to_s
    }
  end
  #ふぁぼられると通知
  plugin.add_event(:favorite) do |post, user, message|
    g.notify "ruby-growl Notification", str+"Favorite by #{user[:idname]}", message.to_s
  end
  #タイムライン更新通知
  plugin.add_event(:update) do |service, message|
    message.each{|msg|
      g.notify "ruby-growl Notification", str+"Update", msg.to_s
     }
  end
end
