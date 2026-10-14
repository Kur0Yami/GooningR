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

// Some published Flutter plugins (e.g. spine_flutter 4.2.36) pin their own
// compileSdk lower than the transitive androidx dependencies they pull in
// require, which fails AAR metadata checks ("is currently compiled against
// android-31" while a dependency needs 34+). Force every subproject/plugin
// (except :app, which is forced to evaluate early by evaluationDependsOn
// below and sets its own compileSdk anyway) to compile against the same,
// newer SDK as the app itself so that check passes, without needing to
// edit the plugin's own (unvendored) source.
subprojects {
    if (project.name != "app") {
        afterEvaluate {
            extensions.findByType(com.android.build.gradle.BaseExtension::class.java)?.let { android ->
                android.compileSdkVersion(36)
            }
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
