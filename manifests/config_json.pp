class docker_compose::config_json ( String $config_json_confdir, String $config_json_owner, Hash $docker_config_json_hash ) {
    file { "$config_json_confdir" :
        ensure => directory,
        mode => '0700',
        owner => $config_json_owner,
        group => root,
    }
    
    file { "$config_json_confdir/config.json" :
        ensure => file,
        mode => '0400',
        owner => $config_json_owner,
        group => root,
        content => inline_template( hash2json( $docker_config_json_hash ) )
    }
}
