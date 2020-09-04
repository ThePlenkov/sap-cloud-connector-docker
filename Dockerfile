FROM openjdk:8-jre

# SCC version
ARG SCC_VERSION=2.12.4

# install dependencies
# lsof is needed for SCC
RUN apt-get update && apt-get install lsof

# download and install sapcc
# ATTENTION:
# This automated download automatically accepts SAP's End User License Agreement (EULA).
# Thus, when using this docker file as is you automatically accept SAP's EULA!
RUN wget --no-cookies --header "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt; path=/;" -O sapcc.tar.gz -S https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.tar.gz && \
  mkdir /tmp/scc_dist && \
  tar -C /tmp/scc_dist -xzof sapcc.tar.gz && \
  mkdir /scc && \
  cp -R /tmp/scc_dist/* /scc


# declare the volume - we expect that it will be used to persist config
VOLUME [ "/scc" ]

COPY ./src/go.sh /
WORKDIR /scc

ENTRYPOINT [ "/go.sh" ]

# expose connector server
EXPOSE 8443