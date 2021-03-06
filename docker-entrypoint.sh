#!/bin/bash

if [ "$1" == npm ]; then

	if [ -n "$DB_PORT_27017_TCP_ADDR" ]; then
		if [ -n "$MONGO_URI" ]; then
			echo >&2 'warging: both DB_PORT_27017_TCP_ADDR and MONGO_URI found'
			echo >&2 "  Connectiong to MONGO_URI ($MONGO_URI)"
			echo >&2 '  instead of linked MongoDB conatiner'
		fi
	elif [ -z "$MONGO_URI" ]; then
		echo >&2 'error: missing DB_PORT_27017_TCP_ADDR and MONGODB_URI environment variables'
		echo >&2 '  Please --link some_mongdb_container:db or set an external db'
		echo >&2 '  with -e MONGO_URI=mongodb://hostname:port'
		exit 1
	fi

	if [ -n "$REDIS_PORT_6379_TCP_ADDR" ]; then
		if [ -n "$REDIS_URL" ]; then
			echo >&2 'warging: both REDIS_PORT_6379_TCP_ADDR and REDIS_URL found'
			echo >&2 "  Connectiong to REDIS_URL ($REDIS_URL)"
			echo >&2 '  instead of linked Redis conatiner'
		else
			export REDIS_URL='redis://redis:6379'
		fi
	fi

	export MONGO_URI=${MONGO_URI:-mongodb://db:27017/}
	export NODE_ENV=${NODE_ENV:-production}

	if [ -z "$PASSWORD_SEED" ]; then
		export PASSWORD_SEED=`head -c1M /dev/urandom | sha1sum | cut -d' ' -f1`
	fi

fi

exec "$@"
