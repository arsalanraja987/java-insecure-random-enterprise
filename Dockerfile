FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

COPY ./src /app/src
COPY InsecureTokenGenerator.java /app/
RUN javac /app/src/main/java/InsecureTokenGenerator.java

CMD ["java", "src.main.java.InsecureTokenGenerator"]
