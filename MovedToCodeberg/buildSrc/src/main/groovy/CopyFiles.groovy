import java.util.regex.Pattern
import java.util.regex.Matcher
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.Files
import java.nio.file.StandardCopyOption
import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.file.FileCollection
import org.gradle.api.file.ConfigurableFileCollection
import org.gradle.api.tasks.OutputFiles
import org.gradle.api.tasks.InputFiles
import org.gradle.api.tasks.Internal
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.SkipWhenEmpty

public abstract class CopyFiles extends DefaultTask {
  @Internal
  FileCollection inputFiles = null
  @Internal
  File outputDirectory = null

  @SkipWhenEmpty
  @InputFiles
  abstract ConfigurableFileCollection getSourceFiles()

  @OutputFiles
  abstract ConfigurableFileCollection getResultFiles()

  public void sources(FileCollection sourceFiles, String pattern) {
    inputFiles = sourceFiles

    // The handling of pattern here is a little crude.
    String inputPattern = pattern.replace(".", "\\.").replace("*", ".*")
    Pattern filePattern = Pattern.compile("${inputPattern}\$")
    inputFiles.each { file ->
      Matcher m = filePattern.matcher(file.getAbsolutePath())
      if (m.matches()) {
        getSourceFiles().from(file)
      }
    }

    if (outputDirectory != null) {
      configureCopy()
    }
  }

  public void output(File directory) {
    if (directory.exists() && !directory.isDirectory()) {
      throw new GradleException("Output must be a directory: ${directory.getAbsolutePath()}")
    }
    if (!directory.exists() && !directory.mkdirs()) {
      throw new GradleException("Failed to create output directory: ${directory.getAbsolutePath()}")
    }
    outputDirectory = directory
    if (inputFiles != null) {
      configureCopy()
    }
  }

  private void configureCopy() {
    String path = outputDirectory.getPath() + System.getProperty("file.separator")
    
    inputFiles.each { file ->
      getResultFiles().from("${path}${file.name}")
    }
  }

  @TaskAction
  void execute() {
    if (inputFiles == null) {
      throw new GradleException("No sources() specified")
    }
    if (outputDirectory == null) {
      throw new GradleException("No output() specified")
    }

    byte[] buffer = new byte[8192]
    String path = outputDirectory.getPath() + System.getProperty("file.separator")
    sourceFiles.each { file ->
      Path inputPath = Paths.get(file.getAbsolutePath())
      Path outputPath = Paths.get("${path}${file.name}")
      Files.copy(inputPath, outputPath, StandardCopyOption.REPLACE_EXISTING)
    }
  }
}
