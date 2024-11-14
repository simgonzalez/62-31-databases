plugins {
    id("java")
}

group = "cours.nosql"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("redis.clients:jedis:5.2.0")
}

tasks.test {
    useJUnitPlatform()
}