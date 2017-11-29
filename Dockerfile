FROM registry.access.redhat.com/rhel7-atomic
MAINTAINER Tero Ahonen <tahonen@redhat.com>
ENV BUILDER_VERSION 1.0
RUN microdnf --enablerepo=rhel-7-server-rpms \
  install wget tar unzip bc java-1.8.0-openjdk-headless --nodocs ;\
  microdnf clean all

LABEL io.k8s.description="Platform for building Mule 3.9.0 CE applications" \
    io.k8s.display-name="Mule 3.9.0 builder 1.0" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,mule-3.9.0"

RUN wget https://repository.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz
RUN cd /opt && tar xvzf ~/mule-standalone-3.9.0.tar.gz
RUN rm ~/mule-standalone-3.9.0.tar.gz
RUN ln -s /opt/mule-standalone-3.9.0 /opt/mule

LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
COPY ./s2i/bin/ /usr/local/s2i

RUN chown -R 1001:1001 /opt && chmod -R 777 /opt

# default user
USER 1001

CMD [ "usage" ]

# Set the default port for applications HTTP and event bus
EXPOSE 8080
