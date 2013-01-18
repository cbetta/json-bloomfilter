require "bundler/gem_tasks"

desc "Set up and run tests"
task :default => [:test]

desc "Run tests"
task :test do
  sh "bundle exec rspec spec"
end


desc "Autobuild JS/SCSS"
task :watch do
  require "bundler/setup"
  require "fssm"

  monitor = FSSM::Monitor.new

  monitor.path "coffee", "**/*.coffee" do
    compile_block = -> basename, filename do
      puts "Compiling coffee to minified js..."
      coffee_file = "coffee/#{filename}"
      puts "\t#{coffee_file}"
      Rake::Task["js:compile_file"].tap(&:reenable).invoke(coffee_file)
      Rake::Task["js:minify_file"].tap(&:reenable).invoke(coffee_file)
    end

    update &compile_block
    delete &compile_block
    create &compile_block
  end

  monitor.run
end


namespace :js do
  desc "Compiles CS & minifies JS"
  task :compile do
    puts "Compiling coffee to minified js..."
    Rake::Task["js:compile_cs"].tap(&:reenable).invoke()
    Rake::Task["js:minify_js"].tap(&:reenable).invoke()
    puts "\t\t->done\n\n"
  end

  task :compile_cs, :filename do |t, args|
    require "coffee-script"

    coffee_script = ""

    %w{bloomfilter bitarray zlib}.each do |library|
      filename = "coffee/#{library}.coffee"
      puts "\t#{filename}"
      coffee_script += File.read(filename) + "\n"
    end

    js_file = "js/json-bloomfilter.js"
    directory_name = File.dirname js_file
    FileUtils.mkdir_p(directory_name) unless File.exists? directory_name
    puts "\t\t->#{js_file}"
    File.open(js_file, "w+") do |f|
      f.print CoffeeScript.compile(coffee_script, no_wrap: true)
    end
  end

  task :minify_js, :filename do |t, args|
    require "yui/compressor"
    filename = args[:filename]
    compressor = YUI::JavaScriptCompressor.new

    js_file = "js/json-bloomfilter.js"
    min_file = "js/json-bloomfilter.min.js"

    puts "\t\t->#{min_file}"
    directory_name = File.dirname min_file
    FileUtils.mkdir_p(directory_name) unless File.exists? directory_name
    File.open(min_file, "w+") do |f|
      f.print compressor.compress(File.read(js_file))
    end
    File.delete js_file
  end

end