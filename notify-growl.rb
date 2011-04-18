# -*- coding: utf-8 -*-
require 'ruby-growl'
Module.new do 
  plugin = Plugin::create(:notify)
  g = Growl.new '127.0.0.1',"ruby-growl", ["ruby-growl Notification"]
  # 取り敢えずメンションがきたら表示するだけ
  plugin.add_event(:mention) do |post, message|
    message.each{|m| 
      msg = m.to_s
      g.notify "ruby-growl Notification", 'mikumiku:mention', msg
    }
  end
end
