import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "1.8.21"
    id("com.diffplug.spotless") version "6.19.0"
    application
    antlr
}

group = "wang.qrwells"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
    antlr("org.antlr:antlr4:4.13.0")
}

tasks.test {
    useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
    dependsOn(tasks.generateGrammarSource)
    kotlinOptions.jvmTarget = "1.8"
}

application {
    mainClass.set("MainKt")
}

tasks.generateGrammarSource {
    maxHeapSize = "64m"
    arguments = arguments + listOf("-visitor", "-long-messages")
}

spotless {
    format("misc") {
        target("*.md", ".gitignore")
        trimTrailingWhitespace()
        indentWithSpaces(4)
        endWithNewline()
    }

    antlr4 {
        target("src/*/antlr/*.g4")
        antlr4Formatter()
    }
}