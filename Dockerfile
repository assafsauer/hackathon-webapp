FROM registry.access.redhat.com/ubi8/openjdk-17:1.14 as builder

COPY --chown=185 . /opt/source/
WORKDIR /opt/source

RUN ./mvnw package -q -Dquarkus.container-image.build=false

FROM registry.access.redhat.com/ubi8/openjdk-17:1.14 as runtime

ENV LANGUAGE='en_US:en'

COPY --from=builder --chown=185 /opt/source/target/quarkus-app/lib/ /deployments/lib/
COPY --from=builder --chown=185 /opt/source/target/quarkus-app/*.jar /deployments/
COPY --from=builder --chown=185 /opt/source/target/quarkus-app/app/ /deployments/app/
COPY --from=builder --chown=185 /opt/source/target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080
USER 185
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"
