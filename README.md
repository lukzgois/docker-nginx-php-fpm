# Docker PHP-FPM Image

Basic image for PHP and Laravel development.  

## Image Contents

- Ubuntu 14.04
- NodeJS 5.x
- Npm
- PHP 7
- Composer
- Nginx
- Supervisor

## Usage

### With `AZK`

Example of using this image with [azk][azk]:

```javascript
systems({
  "app": {
    // Dependent systems
    depends: [], // postgres, mysql, mongodb ...
    // More images:  http://images.azk.io
    image: {"docker": "lukz/php-fpm"},
    // Steps to execute before running instances
    provision: [
      // "composer install",
    ],
    workdir: "/azk/#{manifest.dir}",
    shell: "/bin/bash",
    wait: {"retry": 20, "timeout": 1000},
    mounts: {
      '/azk/#{manifest.dir}': path(".")
    },
    scalable: {"default": 1},
    http: {
      // app.dev.azk.io
      domains: [ "#{system.name}.#{azk.default_domain}" ]
    },
    ports: {
      // exports global variables
      http: "80/tcp",
    },
    envs: {
      // set instances variables
      APP_DIR: "/azk/#{manifest.dir}",
    },
  },
});
```

### Usage with `docker`

To run the image and bind to port 80:

```sh
$ docker run -d -p 80:80 -v "$PWD":/var/www lukz/php-fpm:latest
```

## License

This images is distributed under the [MIT License][license]

[azk]: http://azk.io
[license]: https://github.com/lukzgois/docker-php-fpm/blob/master/LICENSE