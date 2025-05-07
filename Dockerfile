# Java 17 기반 이미지 사용
FROM amazoncorretto:17

# 작업 디렉토리 생성
WORKDIR /app

# build/libs/ 폴더에 있는 JAR 파일을 컨테이너로 복사 (build 후 JAR 파일 이름에 맞춰 수정!)
COPY build/libs/*.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
