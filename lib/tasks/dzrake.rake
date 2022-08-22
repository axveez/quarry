namespace :dzrake do

  task :cekcannel => :environment do |t, args|
    require 'teamspeak-ruby'
    begin
      ts = Teamspeak::Client.new
      ts.login('serveradmin', 'Kmzway87aa@')
      ts.command('use', sid: 1)
      ts.command('logview')
      
      #  UNTUK HELP 

      # puts ts.command('clientaddperm', cldbid: 500,permid: 173,permvalue: 666)
      # clientaddperm cldbid=2 permid=i_client_permission_modify_power permvalue=666 per    
      
        c = 0
        ts.command('channellist').each do |user|
          puts user
          c+=1
        end


        ts.command('channeledit', cid: 325,channel_name: "[cspacer] Current #{c} Member(s) Online")

     
      ts.disconnect
    rescue Teamspeak::ServerError => error
      error.code #=> 1033
      error.message #=> 'server is not running'
    end
  end

	task :cekuser => :environment do |t, args|
		require 'teamspeak-ruby'
		begin
		  ts = Teamspeak::Client.new
			ts.login('serveradmin', 'Kmzway87aa@')
			ts.command('use', sid: 1)
			ts.command('logview')
			
			#  UNTUK HELP 

			puts ts.command('clientedit', clid: 38,client_description: "Nigga Man")
			# puts ts.command('clientaddperm', cldbid: 500,permid: 173,permvalue: 666)
			# clientaddperm cldbid=2 permid=i_client_permission_modify_power permvalue=666 per    
			ts.command('clientlist').each do |user|
				puts user
				# puts ts.command('clientinfo', clid: user["clid"])
				# qVYor8Dz3HsSB0fFl3qaq572wJY=
			end

			puts ts.command('clientinfo', clid: 5)
			# ts.command('channellist').each do |chanel|
			# 	puts chanel
			# 	# puts ts.command('permissionlist', cid: chanel["cid"])
			# end

				# puts ts.command('channelgrouplist', cid: 154)
			# ts.command('clientupdate', client_nickname: "serveradmin", client_nickname: "Ypmlw")			
			# ts.command('clientpoke', clid: 33,msg: 'Woi')
		  ts.disconnect
		rescue Teamspeak::ServerError => error
		  error.code #=> 1033
		  error.message #=> 'server is not running'
		end
	end

	task :pokeuser, [:nama,:target,:message] => :environment do | t, args|   
		require 'teamspeak-ruby'
		begin
		  ts = Teamspeak::Client.new
			ts.login('serveradmin', 'Kmzway87aa@')
			ts.command('use', sid: 1)
			ts.command('logview')
			
			ts.command('clientupdate', client_nickname: "serveradmin", client_nickname: args[:nama])			
			ts.command('clientpoke', clid: args[:target] ,msg: "#{args[:message]}")
		  ts.disconnect
		rescue Teamspeak::ServerError => error
		  error.code #=> 1033
		  error.message #=> 'server is not running'
		end
	end

	task :loop do
		require 'teamspeak-ruby'
		begin
		  ts = Teamspeak::Client.new
			ts.login('serveradmin', 'Kmzway87aa@')
			ts.command('use', sid: 1)
			ts.command('logview')
			
			ts.command('clientupdate', client_nickname: "serveradmin", client_nickname: "OM Jangkrik")
			
			loop do
				puts "BOT"
				#  UNTUK HELP 
				ts.command('channellist').each do |chanel|
					if chanel["cid"].to_i==30 and chanel["total_clients"].to_i >0
            puts "ada"
						ts.command('clientupdate', client_nickname: "serveradmin", client_nickname: "OM Jangkrik")
						poke = true
						ts.command('clientlist').each do |user|
							user_det = ts.command('clientinfo', clid: user['clid'])
							cek_jenis = user_det["client_servergroups"]
							cek_jenis = cek_jenis.to_s.split(",")
							if cek_jenis.include?('6') == true and user_det["cid"].to_i==30 
								poke = false
							end

							if cek_jenis.include?('10') == true and user_det["cid"].to_i==30
								poke = false
							end

							if cek_jenis.include?('22') == true and user_det["cid"].to_i==30
								poke = false
							end
						end

						if poke == true
							puts "Status Poke => #{poke}"
							ts.command('clientlist').each do |user|
							  user_det = ts.command('clientinfo', clid: user['clid'])
								cek_jenis = user_det["client_servergroups"]
								cek_jenis = cek_jenis.to_s.split(",")
								  if cek_jenis.include?('6') == true
									ts.command('clientpoke', clid: user["clid"],
																   msg: 'ada yang butuh bantuan di Support & Troubleshoot!')
									end

									if cek_jenis.include?('10') == true
									ts.command('clientpoke', clid: user["clid"],
																   msg: 'ada yang butuh bantuan di Support & Troubleshoot!')
									end
									if cek_jenis.include?('22') == true
									ts.command('clientpoke', clid: user["clid"],
																   msg: 'ada yang butuh bantuan di Support & Troubleshoot!')
									end
							end
						end
					end
				end

				# UNTUK GREETINGS
        c = 0
				ts.command('clientlist').each do |user|
					ts.command('clientupdate', client_nickname: "serveradmin", client_nickname: "OM Jangkrik")
				  user_det = ts.command('clientinfo', clid: user['clid'])
					cek_jenis = user_det["client_servergroups"]
					cek_jenis = cek_jenis.to_s.split(",")

					if cek_jenis.include?('13') == true
						if user_det['connection_connected_time'].to_i < 11000
						puts "poke #{user['client_nickname']} penjara"
						ts.command('clientpoke', clid: user["clid"],
												   msg: 'Maaf Anda di penjara dengan beberapa alasan, harap tanya admin!')
						end
					puts "move #{user['client_nickname']} penjara"
					ts.command('clientmove', clid: user["clid"],
												   cid: 56)
					end

					if user_det['connection_connected_time'].to_i < 11000 and cek_jenis.include?('8') == true #user["client_nickname"] != "OM Jangkrik"
					puts user["client_nickname"]
					ts.command('clientpoke', clid: user["clid"],
												   msg: 'Welcome to JOSGC Teamspeak! New to Teamspeak? Need help? Get inside Support & Troubleshoot channel.')
					end
          c+=1
				end


        ts.command('channeledit', cid: 325,channel_name: "[cspacer] Current #{c} Member(s) Online")

				sleep 8
			end
		  ts.disconnect
		rescue Teamspeak::ServerError => error
		  error.code #=> 1033
		  error.message #=> 'server is not running'
		  require 'rake'
			Rake::Task['dzrake:loop']
			Rake::Task['dzrake:loop'].reenable
			retry
		end
	end
end