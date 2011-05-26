#!/usr/bin/env ruby
@flags = {:rvm => false, :growl => false, :sdl => false}
ARGV.each do |args|
  @flags[:rvm] = true if /rvm/i =~ args
  @flags[:growl] = true if /growl/i =~ args
  @flags[:sdl] = true if /sdl/i =~ args
end
@rvm_installs = "curl -s https://rvm.beginrescueend.com/install/rvm"
@rvm_settings = "if [[ -s ${HOME}/.rvm/scripts/rvm ]] ; then \n\tsource ${HOME}/.rvm/scripts/rvm\nfi"
def set_type
  return 'sudo port' if File.exist? '/opt/local/bin/port'
  return 'brew' if File.exist? '/usr/local/bin/brew'
  raise "Cannot find package manager MacPorts or Homebrew."
end

def write_shrc str
  sh = File.basename( `echo $SHELL` ).chomp
  shrc = "~/."+sh+"rc"
  `echo "#{str}" >> #{shrc}`
end

def install_rvm
  return nil if Dir.exists?(File.expand_path('~/.rvm'))
  system "#{@rvm}| bash"
  write_shrc @rvm_settings
  `source ~/.rvm/scripts/rvm`
end

def install_ruby ver
  vrr = `rvm list`
  return nil if /#{ver}/ =~ vrr
  `rvm install #{ver}`
  `rvm #{ver} --default`
  `rvm default`
end

if @flags[:rvm]
  install_rvm
  install_ruby "1.9.2"
end

def install_gtk command
  if /port/ =~ command
    if @flags[:rvm]
      `#{command} install gtk2`
      `gem install gtk2`
    else
      `#{command} install rb-gtk2`
      `#{command} install ruby-hmac`
    end
  elsif /brew/ =~ command
    `#{command} install gtk+`
    if @flags[:rvm]
      `gem install gtk2`
      `gem install ruby-hmac`
    else
      `sudo gem install gtk2`
    end
  end
end

def install_growl
  if @flags[:rvm]
    `gem install ruby-growl`
  else
    `sudo gem install ruby-growl`
  end
end

def install_sdl command
  if /port/ =~ command
    `#{command} install libsdl libsdl_sound libsdl_mixer`
  elsif /brew/ =~ command
    `#{command} install sdl sdl_sound sdl_mixer`
  end
  `gem install rubysdl` if @flags[:rvm]
  `sudo gem install rubysdl` unless @flags[:rvm]
end

command = set_type
install_rvm if @flags[:rvm]
install_gtk command
install_growl if @flags[:growl]
install_sdl if @flags[:sdl]

