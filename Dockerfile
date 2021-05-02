# Obtem uma imagem do weblogic 12.1.3 com um base domain configurado
# Console em localhost:7001/console, com user: weblogic e password: welcome1
FROM valada/weblogic_1213_base_domain:1.0

MAINTAINER André Valadares (andre.valadares@gmail.com)

USER root

WORKDIR /u01/oracle/user_projects/domains/base_domain

RUN mkdir -p properties/soma && \
	chmod a+xr ./properties && \
	chown -R oracle:oracle ./properties

# Copia os arquivos de properties para a nova pasta
COPY *.properties ./properties/soma

# Substitui o setDomainEnv pelo arquivo que adiciona um diretorio de propriedades ao classpath
RUN rm /u01/oracle/user_projects/domains/base_domain/bin/setDomainEnv.sh
COPY setDomainEnv.sh /u01/oracle/user_projects/domains/base_domain/bin

# Inicia o servidor
USER oracle
CMD ["/u01/oracle/user_projects/domains/base_domain/startWebLogic.sh"]

