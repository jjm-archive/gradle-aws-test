# 1️⃣ Build Stage
FROM eclipse-temurin:17 AS builder

WORKDIR /app

# Gradle Wrapper + 설정만 먼저 복사해서 의존성 캐싱
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./

RUN chmod +x ./gradlew
RUN ./gradlew dependencies --no-daemon

# 소스 전체 복사 후 실제 빌드
COPY . .
RUN ./gradlew build --no-daemon --parallel --build-cache -x test

# 2️⃣ Run Stage
FROM eclipse-temurin:17

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

# (옵션) Docker 네트워크 바인딩 문서화
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
