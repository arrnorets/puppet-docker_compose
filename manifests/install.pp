class docker_compose::install ( $docker_user, $docker_compose_pkg_version, $docker_pkg_name, $docker_pkg_version ) {
    package { "${docker_pkg_name}" :
        ensure => $docker_pkg_version,
    }

    package { "docker-compose" :
        ensure => $docker_compose_pkg_version,
    }

    file { "/opt/docker-compose" :
        ensure => directory,
	mode => '0700',
	owner => $docker_user,
    }

    file { "/etc/systemd/system/docker-compose@.service":
        ensure => file,
	mode => '0755',
	owner => root,
	group => root,
        content => template("docker_compose/docker-compose.systemd.erb")
    }
}
