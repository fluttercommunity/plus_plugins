allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Only redirect build directories for local subprojects (like :app or other local plugins).
// This avoids "different roots" Gradle build errors on Windows when the project is on
// a different drive (e.g., D:) than the Flutter Pub cache (typically on C:).
// thrown by file_selector_android
subprojects {
    val isLocalProject = project.projectDir.canonicalPath.startsWith(rootProject.projectDir.canonicalPath)
    if (isLocalProject) {
        val newSubProjectBuildDir: Directory = newBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubProjectBuildDir)
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
