def growl(title, msg, img)
  %x{growlnotify -m #{ msg.inspect} -t #{title.inspect} --image ~/.watchr/#{img}.png}
end

def form_growl_message(str)
  msg = str.split("\n").last
  if msg =~ /(\d)\sfailure/
    img = $1.to_i > 0 ? 'fail' : 'pass'
  end
  growl 'Results', msg, img
end

def run(cmd)
  puts cmd
  output = ""
  IO.popen(cmd) do |com|
    com.each_char do |c|
      print c
      output << c
      $stdout.flush
    end
  end
  form_growl_message output
end

def run_spec(path)
  path.gsub!('lib/', 'spec/')
  path.gsub!('_spec', '')
  file_name = File.basename(path, '.rb')
  path.gsub!(file_name, file_name + "_spec")
  run %Q(spec #{path})
end

watch('spec/helper\.rb')  { system('clear'); run('rake') }
watch('lib/.*\.rb')       { |m| system('clear'); run_spec(m[0]) }
watch('spec/.*_spec\.rb') { |m| system('clear'); run_spec(m[0]) }

# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run('rake')
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }

