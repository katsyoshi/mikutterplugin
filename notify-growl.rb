# -*- coding: utf-8 -*-
require 'ruby-growl'
Module.new do 
  plugin = Plugin::create(:notify)
  g = Growl.new '127.0.0.1',"ruby-growl", ["ruby-growl Notification"]
  # 取り敢えずメンションがきたら表示するだけ
  plugin.add_event(:mention) do |post, message|
    message.each{ |msg|
      m = msg.to_s
      g.notify "ruby-growl Notification", "mikumiku:Mention", msg.to_s
    }
  end
  #ふぁぼられると通知
  plugin.add_event(:favorite) do |post, user, message|
    g.notify "ruby-growl Notification", "mikumiku:Favorite by #{user[:idname]}", message.to_s
  end
end
