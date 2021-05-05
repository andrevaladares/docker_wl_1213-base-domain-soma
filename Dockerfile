# Obtem uma imagem do weblogic 12.1.3 com um base domain configurado
# Console em localhost:7001/console, com user: weblogic e password: welcome1
FROM valada/weblogic_1213_base_domain:1.0

MAINTAINER André Valadares (andre.valadares@gmail.com)

USER root

WORKDIR /u01/oracle/user_projects/domains/base_domain

RUN mkdir -p properties/soma && \
	mkdir -p applogs/soma && \
	mkdir -p appfiles/soma && \
	mkdir -p properties/somaweb && \
	mkdir -p applogs/somaweb && \
	mkdir -p appfiles/somaweb
	

# Copia os arquivos de properties para a nova pasta
COPY soma-ric-properties/*.properties ./properties/soma/
COPY soma-dmz-properties/*.properties ./properties/somaweb/

# Substitui o setDomainEnv pelo arquivo que adiciona um diretorio de propriedades ao classpath
RUN rm /u01/oracle/user_projects/domains/base_domain/bin/setDomainEnv.sh
COPY setDomainEnv.sh /u01/oracle/user_projects/domains/base_domain/bin

RUN chown oracle:oracle ./properties && \
	chown oracle:oracle ./properties/soma && \
	chown oracle:oracle ./properties/soma/* && \
	chown oracle:oracle ./bin && \
	chown oracle:oracle ./bin/setDomainEnv.sh && \
	chown oracle:oracle ./appfiles && \
	chown oracle:oracle ./appfiles/soma && \
	chown oracle:oracle ./applogs && \
	chown oracle:oracle ./applogs/soma 

RUN chown oracle:oracle ./properties/somaweb && \
	chown oracle:oracle ./properties/somaweb/* && \
	chown oracle:oracle ./appfiles/somaweb && \
	chown oracle:oracle ./applogs/somaweb 

# Inicia o servidor
USER oracle
CMD ["/u01/oracle/user_projects/domains/base_domain/startWebLogic.sh"]