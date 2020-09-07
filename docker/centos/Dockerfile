FROM centos

# SCC version
ARG SCC_VERSION=2.12.4

# install dependencies
# lsof is needed for SCC
RUN yum update -y && yum install -y java-1.8.0-openjdk which lsof


# download and install sapcc
# ATTENTION:
# This automated download automatically accepts SAP's End User License Agreement (EULA).
# Thus, when using this docker file as is you automatically accept SAP's EULA!
RUN curl -b "eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt; path=/;" --output sapcc.tar.gz https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.tar.gz  && \
    mkdir /tmp/scc_dist && \
    tar -C /tmp/scc_dist -xzof sapcc.tar.gz && \
    mkdir /scc && \
    cp -R /tmp/scc_dist/* /scc

# declare the volume - we expect that it will be used to persist config
VOLUME [ "/scc" ]

COPY ./src/go.sh /
RUN chmod +x /go.sh
WORKDIR /scc

ENTRYPOINT [ "/go.sh" ]

# # expose connector server
# RUN groupadd scc
# RUN useradd -G scc admin
# RUN setfacl -dR -m u:admin:r-x /tmp
# RUN cat /tmp/scc_dist/daemon.sh
# USER admin

EXPOSE 8443