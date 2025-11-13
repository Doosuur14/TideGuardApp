# Build stage
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy from the TideGuard subdirectory (NOTE: Capital G)
COPY TideGuard/pom.xml .
COPY TideGuard/src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
