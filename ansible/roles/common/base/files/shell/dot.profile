# vi: ft=sh

if [ -d "${HOME}/.profile.d" ]
then
	for i in "${HOME}/.profile.d"/*.sh
	do
		if [ -e "$i" ]
		then
			. "$i"
		fi
	done
	unset i
fi

if [ ${BASH+x} ] && [ -f "${HOME}/.bashrc" ]
then
	. "${HOME}/.bashrc"
fi
