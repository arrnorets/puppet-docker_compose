class docker_compose::config ( $docker_user, $compose_configs, $is_enabled ) {

    service { "docker":
        ensure => $is_enabled,
        enable => $is_enabled
    } 

    $composes = keys( $compose_configs )
    $composes.each | String $c | {
        file { "/opt/docker-compose/${c}":
	    ensure => directory, 
	    mode => '0750',
	    owner => $docker_user
	}
        file { "/opt/docker-compose/${c}/docker-compose.yml":
            ensure => file,
	    owner => $docker_user,
	    mode => '0640',
	    content => inline_template( hash2yml($compose_configs[$c]) ),
            notify => Service[ "docker-compose@${c}" ] 
	}
	service { "docker-compose@${c}":
            ensure => $is_enabled,
            enable => $is_enabled,
	    restart => 'cd /opt/docker-compose/${c} && docker-compose up -d',
	    require => Class[ "docker_compose::install" ],
	}

    } 

}

