# 1️⃣ Build Stage
FROM eclipse-temurin:17 AS builder

WORKDIR /app

# gradle 관련 파일 복사
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./

# gradlew에 실행 권한 부여
RUN chmod +x ./gradlew

# 의존성 먼저 받기 (캐싱 효과 극대화)
RUN ./gradlew dependencies --no-daemon

# 나머지 소스 복사
COPY . .

# 빌드 (테스트 제외)
RUN ./gradlew build --no-daemon --parallel --build-cache -x test

# 2️⃣ Run Stage
FROM eclipse-temurin:17

WORKDIR /app

# 빌드된 JAR 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 앱 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
