#!/bin/bash
#set -x

if [ "$1" == "-c" ]; then

	if [ "$2" == "" ]; then
		echo "Trebuie sa dai ca parametru numele noului site."
		exit
	fi

	if [ "$3" == "" ]; then
		echo "Trebuie sa dai ca parametru calea catre noul site."
		exit
	fi

	cale=$3
	first=${cale:0:1}
	if [ "$first" != "/" ]; then 
		cale=$(pwd)"/"$cale
	fi

	[ ! -d $cale ] && mkdir $cale

	if [ ! -d $cale ]; then
		echo "Directorul pentru noul site nu s-a putut crea.";
		exit
	fi

	last=${cale#${cale%?}}
	if [ "$last" == "/" ]; then 
		cale=${cale%?}
	fi

	sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/$site

	www="/var/www"
	www="${www//\//\\/}"
	new="${cale//\//\\/}"
	sudo sed -i "s/${www}/${new}/g" "/etc/apache2/sites-available/$site"

	chmod -R 777 $cale

	sudo a2ensite $2

	sudo service apache2 restart

elif [ "$1" == "-r" ]; then

	if [ "$2" == "" ]; then
		echo "Trebuie sa dai ca parametru numele site-ului pe care vrei sa-l stergi."
		ls "/etc/apache2/sites-available"
		exit
	fi

	sudo a2dissite $2
	sudo rm -R "/etc/apache2/sites-available/$2"

elif [ "$1" == "-a" ]; then

	if [ "$2" == "" ]; then
		echo "Trebuie sa dai ca parametru numele site-ului pe care vrei sa-l activezi."
		ls "/etc/apache2/sites-available"
		exit
	fi

	sudo a2ensite $2

else 

	echo "-c nume_site calea/catre/noul/site";
	echo "-r nume_site";
	echo "-a nume_site"

fi
