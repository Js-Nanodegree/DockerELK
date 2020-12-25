FROM debian:buster-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	gnupg2 \
	wget \
	ca-certificates \
	procps

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update && apt-get install -y --no-install-recommends \
	elasticsearch \
	logstash \
	kibana

RUN apt-get autoremove -y

COPY ./logstash.conf /etc/logstash/conf.d/logstash.conf
COPY ./logstash.yml /etc/logstash/logstash.yml
COPY ./kibana.yml /etc/kibana/kibana.yml

COPY ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 5601 9200 5044

CMD /usr/local/bin/start.sh
