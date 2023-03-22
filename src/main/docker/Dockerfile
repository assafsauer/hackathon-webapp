FROM registry.access.redhat.com/ubi8/openjdk-17:1.14 as builder

RUN curl -fsSL https://github.com/takari/maven-wrapper/archive/refs/tags/maven-wrapper-0.5.6.tar.gz -o maven-wrapper.tar.gz \
    && tar -xzf maven-wrapper.tar.gz \
    && rm maven-wrapper.tar.gz \
    && cd maven-wrapper-* \
    && ./mvnw --version \
    && mv ./mvnw /usr/bin/mvnw \
    && cd .. \
    && rm -r maven-wrapper-*

COPY . /opt/source/
WORKDIR /opt/source

RUN /usr/bin/mvnw package

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
