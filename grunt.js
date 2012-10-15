/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-exec');
  grunt.loadNpmTasks('grunt-clean');
  grunt.loadNpmTasks('grunt-jasmine-node');

  // Project configuration.
  grunt.initConfig({
    lint: {
      files: ['grunt.js']
    },
    watch: {
      files: '<config:lint.files>',
      tasks: 'lint test'
    },

    clean: {
      folder: "build"
    },

    coffee: {
      app: {
        src: ['lib/**/*.coffee', 'spec/**/*.coffee'],
        dest: 'build',
        options: {
          preserve_dirs: true
        }
      },
    },


    browserify: {
      "build/dist/marsbars.js": {
        entries: ['build/lib/marsbars.js'],
        prepend: ['<banner:meta.banner>'],
      },
      "build/dist/ember.js": {
        entries: ['build/lib/ember.js'],
        prepend: ['<banner:meta.banner>'],
      }
    },
    pkg: '<json:package.json>',
    meta: {
      banner: '\n/*! <%= pkg.title || pkg.name %> - v<%=pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n ' + '<%= pkg.homepage ? "* " + pkg.homepage + "\n *\n " : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;\n' +
        ' * Licensed under the <%= _.pluck(pkg.licenses, "type").join(", ") %> license */'
    },


    exec: {
      compile_grammar: {
        command: 'pegjs lib/marsbars.pegjs build/lib/marsbars.parser.js'
      }
    },

    jasmine_node: {
      spec: "./build/spec",
      projectRoot: ".",
      requirejs: false,
      forceExit: true,
    }

  });

  // Default task.
  grunt.registerTask('default', 'clean coffee exec:compile_grammar browserify jasmine_node');

};
