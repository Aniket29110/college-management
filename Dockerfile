# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application in Tomcat
FROM tomcat:10.1-jdk21-temurin
# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the built WAR file to Tomcat webapps as ROOT.war
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
