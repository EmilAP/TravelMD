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

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// AGP 8+ requires explicit namespace in every Android module.
// Some third-party plugins (for example older isar_flutter_libs) may still
// rely on AndroidManifest package without declaring namespace.
fun Project.assignMissingAndroidNamespace() {
    val androidExt = extensions.findByName("android") ?: return

    val getNamespace = androidExt.javaClass.methods.firstOrNull {
        it.name == "getNamespace" && it.parameterCount == 0
    } ?: return

    val currentNamespace = getNamespace.invoke(androidExt) as? String
    if (!currentNamespace.isNullOrBlank()) {
        return
    }

    val manifestPackage = run {
        val manifestFile = file("src/main/AndroidManifest.xml")
        if (!manifestFile.exists()) {
            null
        } else {
            val manifestText = manifestFile.readText()
            Regex("""package\s*=\s*\"([^\"]+)\"""")
                .find(manifestText)
                ?.groupValues
                ?.getOrNull(1)
        }
    }

    val fallbackNamespace =
        manifestPackage ?: "dev.travelmd.autons.${name.replace('-', '_')}"

    val setNamespace = androidExt.javaClass.methods.firstOrNull {
        it.name == "setNamespace" && it.parameterCount == 1
    } ?: return

    setNamespace.invoke(androidExt, fallbackNamespace)
    logger.lifecycle("[travelmd] Assigned namespace '$fallbackNamespace' to project $path")
}

subprojects {
    plugins.withId("com.android.application") {
        assignMissingAndroidNamespace()
    }
    plugins.withId("com.android.library") {
        assignMissingAndroidNamespace()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
