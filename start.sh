if [ -n "$ES_PASSWORD" ]; then
	${LS_HOME}/bin/system-install
	echo "$ES_PASSWORD" | /usr/share/elasticsearch/bin/elasticsearch-keystore add -f -x "bootstrap.password"
	/usr/share/kibana/bin/kibana-keystore create --allow-root
	echo "elastic" | /usr/share/kibana/bin/kibana-keystore add --allow-root -f -x "elasticsearch.username"
	echo "$ES_PASSWORD" | /usr/share/kibana/bin/kibana-keystore add --allow-root -f -x "elasticsearch.password"
fi

service elasticsearch start
service logstash start
service kibana start

tail -f /dev/null