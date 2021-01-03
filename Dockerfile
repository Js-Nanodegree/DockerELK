FROM debian:buster-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV LS_HOME=/usr/share/logstash
ENV ES_HOME=/usr/share/elasticsearch
ENV KIBANA_HOME=/usr/share/kibana

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

COPY ./elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY ./jvm.options /etc/logstash/jvm.options
COPY ./startup.options /etc/logstash/startup.options
COPY ./logstash.conf /etc/logstash/conf.d/logstash.conf
COPY ./logstash.yml /etc/logstash/logstash.yml
COPY ./kibana.yml /etc/kibana/kibana.yml

RUN mkdir -p ${LS_HOME}/config

RUN ln -s /etc/logstash/logstash.yml ${LS_HOME}/config/logstash.yml
RUN ln -s /etc/logstash/conf.d/logstash.conf ${LS_HOME}/config/log4j2.properties
RUN ln -s /etc/logstash/startup.options ${LS_HOME}/config/startup.options

COPY ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 5601 9200 5044

CMD /usr/local/bin/start.sh
