class docker_compose {

    #Get all information about wireguard settings from Hiera using "hash" merging strategy.
    $hash_from_hiera = lookup('docker_compose', {merge => 'deep'}) 
    $docker_compose_config = $hash_from_hiera['config'] ? { undef => 'false', default => $hash_from_hiera['config'] }
    $docker_compose_enable = $hash_from_hiera['enable'] ? { undef => 'false', default => $hash_from_hiera['enable'] }

    $docker_compose_version = $hash_from_hiera['docker_compose_pkg_version'] ? { undef => 'present', default => $hash_from_hiera['docker_compose_pkg_version'] }
    $docker_pkg_name_value = $hash_from_hiera['docker_pkg_name'] ? { undef => 'docker-ce', default => $hash_from_hiera['docker_pkg_name'] }
    $docker_version = $hash_from_hiera['docker_pkg_version'] ? { undef => 'present', default => $hash_from_hiera['docker_pkg_version'] }

    $docker_username = $hash_from_hiera['docker_username'] ? { undef => 'dockerman', default => $hash_from_hiera['docker_username'] }

    $docker_config_json_hash_value = $hash_from_hiera['docker_config_json'] ? { undef => {}, default => $hash_from_hiera['docker_config_json'] }

    class { "docker_compose::install" :
        docker_user => $docker_username,
        docker_compose_pkg_version => $docker_compose_version,
        docker_pkg_name => $docker_pkg_name_value,
	docker_pkg_version => $docker_version
    }

    class { "docker_compose::config_json" :
        config_json_confdir => $docker_config_json_hash_value['confdir'],
        config_json_owner => $docker_username,
        docker_config_json_hash => $docker_config_json_hash_value['config']
    }

    if ( $docker_compose_config != false ) {
        class { "docker_compose::config" :
	    docker_user => $docker_username,
            compose_configs => $docker_compose_config,
	    is_enabled => $docker_compose_enable
        }
    }
    else {
        notify { "No config." : }
    }
}

