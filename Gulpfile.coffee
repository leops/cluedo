gulp = require 'gulp'
coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'
autoprefixer = require 'autoprefixer-stylus'
fork = require('child_process').fork
repl = require 'repl'
server = null
path =
    js: 'src/**/*.coffee'
    css: 'src/**/*.styl'
    server: 'index.coffee'
    bower: [
        'bower_components/bootstrap/dist/css/bootstrap.min.css',
        'bower_components/jquery/dist/jquery.min.js',
        'bower_components/angularjs/angular.min.js',
        'bower_components/bootstrap/dist/js/bootstrap.min.js'
    ]

gulp.task 'build:js', ->
    gulp.src(path.js)
        .pipe(coffee())
        .pipe(gulp.dest('assets/'))

gulp.task 'build:css', ->
    gulp.src(path.css)
        .pipe(stylus(
            use: autoprefixer()
            compress: true
            sourcemap:
                inline: true
                sourceRoot: '..'
                basePath: 'css'
        ))
        .pipe(gulp.dest('assets/'))

gulp.task 'build:bower', ->
    gulp.src(path.bower)
        .pipe(gulp.dest('assets/bower/'))

gulp.task 'watch', ->
    gulp.watch path.js, ['build:js']
    gulp.watch path.css, ['build:css']
    gulp.watch path.server, ['serve']

gulp.task 'serve', ->
    if server?
        server.kill 'SIGKILL'
    else
        start = ->
            try
                fork(path.server)
                    .on('error', console.error.bind(console))
                    .on 'exit', -> server = start()
            catch err
                console.error err
        server = start()

gulp.task 'build', ['build:js', 'build:css', 'build:bower']
gulp.task 'default', ['build', 'watch', 'serve']
