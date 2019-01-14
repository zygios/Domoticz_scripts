local RunInterval = 1 --run interval in minutes
local ping = {}
	ping['192.16x.x.xx']={'PC',0}
	ping['192.16x.x.xx']={'OrangePC',0}
	ping['192.16x.x.xx']={'NAS',0}
	ping['192.16x.x.xx']={'TV',0}


return {
	on = {
		timer = {
			'every '..tostring(RunInterval)..' minutes',
		},
	},
	
	execute = function(domoticz, item)
		local arp = {} -- Table pour les lignes du fichier

		if (domoticz.utils.fileExists("/proc/net/arp"))then
			local file = io.open("/proc/net/arp", "r") -- Ouvre le fichier en mode lecture
			local ligne = {} -- Table pour les lignes du fichier

			for line in file:lines() do -- Pour chaque lignes
				table.insert(arp, line) -- On insère les lignes dans la table
			end


			i =0
			for i,r in pairs(arp) do
				switch = arp[i]:sub(1,arp[i]:find(" ")-1) --Extraction des IP de la table ARP
				if(ping[switch]~=nil)then -- IP recherchée
					if arp[i]:find("0x2")~=nil then --Flag 0x2 => IP connue sur le réseau, connectée
						domoticz.log("arp success "..ping[switch][1], domoticz.LOG_DEBUG)
						ping[switch][2]=1 -- flag pour mise à On
					else
						--Adresse IP connue mais déconnectée
						domoticz.log("arp fail "..ping[switch][1], domoticz.LOG_DEBUG)
						ping[switch][2]=2 -- Flag pour mise à Off
					end 
				end
			end
			for ip, switch in pairs(ping) do
				os.execute('ping -c10 -W1 '..ip..' &') -- lancement d'un ping sur les IP à tester pour forcer la MAJ ARP
				if(switch[2]==1)then
					domoticz.log(ip..' '..switch[1]..' On actuellement '..domoticz.devices(switch[1]).state, domoticz.LOG_DEBUG)
					if (domoticz.devices(switch[1]).state=='Off')then
						domoticz.devices(switch[1]).switchOn()
					end
				elseif(switch[2]==2)then
					domoticz.log(ip..' '..switch[1]..' Off actuellement '..domoticz.devices(switch[1]).state, domoticz.LOG_DEBUG)
					if (domoticz.devices(switch[1]).state=='On')then
						domoticz.devices(switch[1]).switchOff()
					end
				else
					--@IP non trouvée dans le fichier ARP
					--On le ping à l'ancienne
					domoticz.log("IP "..ip.." non trouvée dans ARP", domoticz.LOG_DEBUG)
					if os.execute('ping -c1 -W1 '..ip) then
						domoticz.log("Ping "..ip.." "..switch[1].." On actuellement "..domoticz.devices(switch[1]).state, domoticz.LOG_DEBUG)
						if (domoticz.devices(switch[1]).state=='Off')then
							domoticz.devices(switch[1]).switchOn()
						end
					else
						domoticz.log("IP injoignable "..switch[1].." Off actuellement "..domoticz.devices(switch[1]).state, domoticz.LOG_DEBUG)
						if (domoticz.devices(switch[1]).state=='On')then
							domoticz.devices(switch[1]).switchOff()
						end
					end
				end
			end
		else
			domoticz.log('Erreur lecture fichier arp', domoticz.LOG_ERROR)
		end
    end
}