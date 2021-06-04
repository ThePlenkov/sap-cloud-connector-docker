FROM oraclelinux:8

ARG JVM_VERSION=8.1.075
ARG JVM_FILENAME=/tmp/jvm.rpm

# Download and install SAP JVM
RUN curl -b "eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt; path=/;" --output ${JVM_FILENAME} https://tools.hana.ondemand.com/additional/sapjvm-${JVM_VERSION}-linux-x64.rpm
RUN rpm -i ${JVM_FILENAME}
RUN rm ${JVM_FILENAME}
ENV JAVA_HOME /usr/java/sapjvm_8_latest

# Download and install SCC
ARG SCC_VERSION=2.13.1
ARG SCC_FILENAME=/tmp/scc.zip

RUN curl -b "eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt; path=/;" --output ${SCC_FILENAME} https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.zip
RUN yum install unzip lsof -y
RUN unzip ${SCC_FILENAME} -d /tmp
RUN yum localinstall /tmp/com.sap.scc-ui-${SCC_VERSION}-8.x86_64.rpm -y
RUN rm ${SCC_FILENAME}
RUN rm /tmp/com.sap.scc-ui-${SCC_VERSION}-8.x86_64.rpm 

# backup installed distributive ( to update cached runtime from the volume, see src/go.sh )
# RUN cd /opt/sap/scc/ && ./useFileUserStore.sh
RUN cp -r /opt/sap/scc /tmp/scc_dist


# prepare go.sh
COPY ./src/go.sh /
RUN chmod +x /go.sh

# user is needed for k8s
RUN groupmod -g 1000 sccgroup
RUN usermod -u 1000 sccadmin
# RUN groupadd sccgroup
# RUN adduser --disabled-password --gecos "SAP Cloud Connector Admin" --ingroup sccgroup sccadmin
# RUN adduser --comment "SAP Cloud Connector Admin" --groups sccgroup sccadmin

RUN chown -R sccadmin:sccgroup /tmp /opt/sap
# RUN /opt/sap/scc/useFileUserStore.sh
USER sccadmin

# declare the volume - we expect that it will be used to persist config
VOLUME [ "/opt/sap/scc" ]

WORKDIR /opt/sap/scc
ENTRYPOINT [ "/go.sh" ]

EXPOSE 8443
