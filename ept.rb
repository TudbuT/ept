def help
  puts '
Usage: ept [action] [<*params>]
  Where action is one of:
    install
      Install an application package
      Where *params is an application ID
    uninstall
      Uninstall an application package
      Where *params is an application ID
    update
      Update/Upgrade all applications
    update_list
      Update the ept_applist
    get_list
      Print the ept_applist
    search
      Search for any application
      Where *params is a search string
    set_bridge
      Set default bridge (like apt, dnf, pkg)
    help
      This'
end

def update_list
  puts '      Please wait... Downloading the lists...'
  pipe = IO.popen 'cd /var && rm -rf ept_applist.eptlist && wget https://ept.glitch.me/ept_applist.eptlist'
  while (s = pipe.gets) != nil
    puts s
  end
  puts '      Done!'
end

def get_list
  if File.exists? '/var/ept_applist.eptlist'
    file = File.new '/var/ept_applist.eptlist', 'r+'
    file.readlines.join(';;').split("\n").join('').split(';;')
  else
    update_list
    get_list
  end
end

def update_bridge
  puts '      Please wait... Downloading the default config...'
  pipe = IO.popen 'cd /var && rm -rf ept_default_bridge.eptcfg && wget https://ept.glitch.me/ept_default_bridge.eptcfg'
  while (s = pipe.gets) != nil
    puts s
  end
  puts '      Done!'
end

def get_bridge
  if File.exists? '/var/ept_default_bridge.eptcfg'
    file = File.new '/var/ept_default_bridge.eptcfg', 'r+'
    file.readlines.join(';;').split("\n").join('').split(';;')
  else
    update_bridge
    get_bridge
  end
end

def set_bridge(bridge)
  if File.exists? '/var/ept_default_bridge.eptcfg'
    file = File.new '/var/ept_default_bridge.eptcfg', 'w'
    file.write bridge
    file.close
    get_bridge
  else
    update_bridge
    set_bridge bridge
    get_bridge
  end
end


def run(command)
  pipe = IO.popen command
  while (s = pipe.gets) != nil
    puts s
  end
end

def install(application)
  puts 'Installing...'
  use = get_bridge[0]
  es = nil
  list = get_list
  list.each do |entry|
    if (entry.downcase.split '::')[0] == application
      es = entry.split '::'
      use = es[5] == '__d__' ? use : es[5]
    end
  end
  if use == '__ept:ept__'
    run "(echo 'ruby #{__FILE__} $@'>/bin/ept) && chmod a+x /bin/ept && cd #{__dir__} && rm -rf ept.rb.old && mv ept.rb ept.rb.old && wget https://ept.glitch.me/ept.rb && chmod a+rw ept.rb"
  elsif use == '__c__'
    run "yes | (#{es[6]})"
  else
    puts "Using bridge '#{use}'"
    run "yes | #{use} install #{application}"
  end
end

def uninstall(application)
  puts 'Uninstalling...'
  use = get_bridge[0]
  es = nil
  list = get_list
  list.each do |entry|
    if (entry.downcase.split '::')[0] == application
      es = entry.split '::'
      use = es[5] == '__d__' ? use : es[5]
    end
  end
  if use == '__ept:ept__'
    run "(echo '#ruby #{__FILE__} $@'>/bin/ept) && chmod a+x /bin/ept && cd #{__dir__} && rm -rf ept.rb.old && mv ept.rb ept.rb.old"
  elsif use == '__c__'
    run "yes | (#{es[7]})"
  else
    puts "Using bridge '#{use}'"
    run "yes | #{use} remove #{application}"
  end
end

def update
  puts 'Updating...'
  use = get_bridge[0]
  update_list
  run "(echo 'ruby #{__FILE__} $@'>/bin/ept) && chmod a+x /bin/ept && cd #{__dir__} && rm -rf ept.rb.old && mv ept.rb ept.rb.old && wget https://ept.glitch.me/ept.rb && chmod a+rw ept.rb"
  run "yes | (#{use} update && #{use} upgrade)"
end

def search(str)
  puts 'Searching...'
  r = "\nRESULTS:"
  list = get_list
  list.each do |entry|
    if entry.downcase.include? str.downcase
      es = (entry.split '::')
      r << "\n\nID: #{es[0]}\nCommands: #{es[1]}\nName: #{es[2]}\nDescription: #{es[3]}"
    end
  end
  r
end


case ARGV[0].to_s.downcase
when 'help'
  help
when 'install'
  puts install ARGV[1]
when 'uninstall'
  puts uninstall ARGV[1]
when 'update'
  puts update
when 'update_list'
  puts update_list
when 'get_list'
  puts get_list.join "\n"
when 'set_bridge'
  set_bridge ARGV[1]
when 'search'
  puts search ARGV[1..-1].join(' ')
else
  help
end
