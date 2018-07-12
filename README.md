Grading environment with specific Scala version in path.

This image extends [grade-java](https://github.com/apluslms/grade-java).
In addition, this image provides following convenience utilities.

* `scala-compile [-M] [-m ok_message] [files/dirs..]`

    Passes `files/dirs` to `move-to-package-dirs` and then executes `scalac` with all matched files.
    If `files/dirs` is empty (no argument), then all `*.scala` files in the working tree are moved and compiled.

    You can control classpath via `CLASSPATH` environment variable.
    You can define options for `scalac` using `SCALACFLAGS` environment variable.
    Default options are `-encoding utf-8 -deprecation -feature -language:postfixOps`.

    If compilation is successfull, then `ok_message` is printed.
    By default, it is `ok`, but it can be suppressed with `-M`.
