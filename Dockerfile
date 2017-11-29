FROM registry.access.redhat.com/rhel7-atomic
MAINTAINER Nobody <nobody@example.com>
ENV BUILDER_VERSION 1.0
ENV MULE_VERSION 3.9.0
ENV MULE_DOWNLOAD_URL=https://repository.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz
RUN microdnf --enablerepo=rhel-7-server-rpms \
  install tar unzip bc which lsof java-1.8.0-openjdk-headless --nodocs ;\
  microdnf clean all

LABEL io.k8s.description="Platform for building Mule ${MULE_VERSION} CE applications" \
    io.k8s.display-name="Mule ${MULE_VERSION} builder 1.0" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,mule-${MULE_VERSION}"

RUN wget ${MULE_DOWNLOAD_URL}
RUN cd /opt && tar xvzf ~/mule-standalone-${MULE_VERSION}.tar.gz
RUN rm ~/mule-standalone-${MULE_VERSION}.tar.gz
RUN ln -s /opt/mule-standalone-${MULE_VERSION} /opt/mule

LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
COPY ./s2i/bin/ /usr/local/s2i

RUN chown -R 1001:1001 /opt && chmod -R 777 /opt

# default user
USER 1001

CMD [ "usage" ]

# Set the default port for applications HTTP and event bus
EXPOSE 8080
