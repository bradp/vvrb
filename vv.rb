#! /usr/bin/env ruby
require 'slop'
require 'colorize'
require 'json'

class Vv

	def initialize
		Vv.get_path
		# puts "Path is " + $path.colorize(:red)
	end

	def self.about
		puts "
	 ██    ██ ██    ██
	░██   ░██░██   ░██ 	 ▓▓▓▓▓▓▓▓▓▓
	░░██ ░██ ░░██ ░██  	░▓ author ▓  Brad Parbs <brad@bradparbs.com>
	 ░░████   ░░████  	░▓ github ▓  http://github.com/bradp/vv
	  ░░██     ░░██  	░▓▓▓▓▓▓▓▓▓▓
	   ░░       ░░  	░░░░░░░░░░
	".colorize( :magenta )
	end

	def self.version
		puts "0.0.1"
	end

	def self.listsites
		sites = Dir.entries( $path + '/www' ).select {|entry| File.directory? File.join( $path + '/www' ,entry) and !(entry =='.' || entry == '..') }
		sites.each { |site|
			if site.to_s != 'wp-cli' && site.to_s != 'default' &&  site.to_s != 'phpcs'
				printf "	* %-35s (%s) %s\n", site.colorize( :green ), Vv.get_url_of_site( site ).colorize( :yellow ), if $default == true then '[VVV default]'.colorize( :light_blue ) end
			end
		}
	end

	def self.get_url_of_site ( site )
		if site.to_s == 'wordpress-default'
			$default = true
			return 'local.wordpress.dev'
		elsif site.to_s == 'wordpress-develop'
			$default = true
			return 'src.wordpress-develop.dev'
		elsif site.to_s == 'wordpress-trunk'
			$default = true
			return 'local.wordpress-trunk.dev'
		else
			$default = false
			return File.read( $path + '/www/' + site + '/vvv-hosts' ).gsub( "\n", " ").rstrip()
		end
	end

	def self.create

	end

	def self.remove

	end

	def self.update

	end

	def self.vagrant_pass_through

	end

	def self.get_path
		if File.exist?( File.expand_path( '~/.vv-new-config' ) )
			vv_config = JSON.parse( File.read( File.expand_path( '~/.vv-new-config' ) ) )
			if File.file?( File.expand_path( vv_config['path'] + 'Vagrantfile' ) )
				$path = vv_config['path']
				return
			end
		end

		if File.file?( File.expand_path( '~/Sites/Vagrantfile' ) )
			$path = File.expand_path( "~/Sites/" )
			return
		elsif File.file?( File.expand_path( '~/vagrant/Vagrantfile' ) )
			$path = File.expand_path( "~/vagrant/" )
			return
		elsif File.file?( File.expand_path( '~/vagrant-local/Vagrantfile' ) )
			$path = File.expand_path( "~/vagrant-local/" )
			return
		elsif File.file?( File.expand_path( '~/projects/vvv/Vagrantfile' ) )
			$path = File.expand_path( "~/projects/vvv/" )
			return
		elsif File.file?( File.expand_path( '~/working/vvv/Vagrantfile' ) )
			$path = File.expand_path( "~/working/vvv/" )
			return
		elsif File.file?( File.expand_path( '~/vvv/Vagrantfile' ) )
			$path = File.expand_path( "~/vvv/" )
			return
		else
			print "Path to your VVV installation? ".colorize( :yellow )
			ARGV.clear
			$path = gets.chomp
			if File.file?( File.expand_path( $path + '/Vagrantfile' ) )
				save_to_vv_config
				$path =  File.expand_path( $path )
			else
				puts "That isn't a valid VVV path.".colorize( :red )
				get_path
			end
		end
	end

	def self.save_to_vv_config
		File.open( File.expand_path( '~/.vv-new-config' ), 'w') do |f|
			f.puts "{" + '"path":' +$path.to_json + "}"
		end
	end

end

class VvDeployments

	def create

	end

	def remove

	end

	def configure

	end

end

class VvBlueprints

	def create

	end

end

opts = Slop.parse( ignore_case: true, help: true ) do
	on '--version', 'Print the version.' do
		Vv.version
	end
	on '--about', 'Print the about text.' do
		Vv.about
	end

	command 'list' do
		description 'Lists all VVV sites.'
		run do |opts, args|
			Vv.get_path
			Vv.listsites
		end
	end

	command 'create' do
		description 'create a VVV site.'

		on :v, :verbose, 'Enable verbose mode'

		run do |opts, args|
			# puts "You ran 'create' with options #{opts.to_hash} and args: #{args.inspect}"
		end
	end

	command 'remove' do
		description 'remove a VVV site.'

		on :v, :verbose, 'Enable verbose mode'

		run do |opts, args|
			# puts "You ran 'remove' with options #{opts.to_hash} and args: #{args.inspect}"
		end
	end
end

vv = Vv.new
