FROM openjdk:8-jre

# SCC version
ARG DEBIAN_FRONTEND=noninteractive
ARG SCC_VERSION=2.13.1

# install dependencies
# lsof is needed for SCC
RUN apt-get update -y && apt-get install -y --no-install-recommends lsof curl

RUN adduser --disabled-password --gecos "SAP Cloud Connector Admin" sccadmin
RUN chown -R sccadmin:sccadmin /tmp

RUN mkdir scc && chown -R sccadmin:sccadmin /scc
RUN chmod 777 /scc

COPY ./src/go.sh /
RUN chmod +x /go.sh

USER sccadmin

# download and install sapcc
# ATTENTION:
# This automated download automatically accepts SAP's End User License Agreement (EULA).
# Thus, when using this docker file as is you automatically accept SAP's EULA!
RUN curl -b "eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt; path=/;" --output /tmp/sapcc.tar.gz https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.tar.gz  && \
  mkdir /tmp/scc_dist && \
  tar -C /tmp/scc_dist -xzof /tmp/sapcc.tar.gz && \
  cp -R /tmp/scc_dist/* /scc

# declare the volume - we expect that it will be used to persist config
VOLUME [ "/scc" ]

WORKDIR /scc
ENTRYPOINT [ "/go.sh" ]

EXPOSE 8443
