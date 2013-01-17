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

    Dir["coffee/**/*.coffee"].each do |coffee_file|
      puts "\t#{coffee_file}"
      Rake::Task["js:compile_file"].tap(&:reenable).invoke(coffee_file)
      Rake::Task["js:minify_file"].tap(&:reenable).invoke(coffee_file)
      puts "\t\t->done\n\n"
    end
  end

  task :compile_file, :filename do |t, args|
    require "coffee-script"
    filename = args[:filename]
    js_file = filename.gsub(%r{coffee/(.+)\.coffee}, "js/\\1.js")
    directory_name = File.dirname js_file
    FileUtils.mkdir_p(directory_name) unless File.exists? directory_name
    puts "\t\t->#{js_file}"
    File.open(js_file, "w+") do |f|
      f.print CoffeeScript.compile(File.read(filename), no_wrap: true)
    end
  end

  task :minify_file, :filename do |t, args|
    require "yui/compressor"
    filename = args[:filename]
    compressor = YUI::JavaScriptCompressor.new

    js_file = filename.gsub(%r{coffee/(.+)\.coffee}, "js/\\1.js")
    min_file = filename.gsub(%r{coffee/(.+)\.coffee}, "js/\\1.min.js")

    puts "\t\t->#{min_file}"
    directory_name = File.dirname min_file
    FileUtils.mkdir_p(directory_name) unless File.exists? directory_name
    File.open(min_file, "w+") do |f|
      f.print compressor.compress(File.read(js_file))
    end
    File.delete js_file
  end

end