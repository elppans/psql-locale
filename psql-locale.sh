#!/bin/bash

if ! grep '55/* *	* * *	root  /usr/local/bin/psql-locale.sh' /etc/crontab ; then
sudo tee -a /etc/crontab &>>/dev/null <<'EOF'

# Verifcar locale pt_BR ISO-8859-1 no sistema a cada NN Minutos
55/* *	* * *	root  /usr/local/bin/psql-locale.sh' /etc/crontab
#

EOF
fi

if grep '^# pt_BR ISO-8859-1' /etc/locale.gen ; then
	sudo sed -i 's/^# *pt_BR ISO-8859-1/pt_BR ISO-8859-1/' /etc/locale.gen
	LOGEN="1"
	PSQLRST="1"
	export LOGEN
	export PSQLRST
fi
if grep '^# pt_BR ISO-8859-1' /etc/locale.alias ; then
	sudo sed -i 's/^# *pt_BR ISO-8859-1/pt_BR ISO-8859-1/' /etc/locale.alias
	LOGEN="1"
	PSQLRST="1"
	export LOGEN
	export PSQLRST
fi

if [ "$LOGEN" == "1" ]; then
	sudo locale-gen
fi

if [ "$PSQLRST" == "1" ]; then
	sudo systemctl restart postgresql@14-main.service
fi


