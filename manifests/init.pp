define selinux( $state, $type ) {

        package { "$name":
                name => $::operatingsystem ? {
                        "CentOS" => "selinux-policy",
                        "RedHat" => "selinux-policy",
                        "OracleLinux" => "selinux-policy",
                },

                ensure => latest,
        }

        case $state {
                "disabled": {
                        exec { "setenforce 0":
                                onlyif => '[ $(sestatus | grep "Current mode" | awk \'{print $3}\') == "enforcing" ]'
                        }
                }
                "enforced": {
                        exec { "setenforce 1":
                                onlyif => '[ $(sestatus | grep "Current mode" | awk \'{print $3}\') == "permissive" ]'
                        }
                }
        }

        file { "selinux":
                name => $::operatingsystem ? {
                        "CentOS" => "/etc/selinux/config",
                        "RedHat" => "/etc/selinux/config",
                        "OracleLinux" => "/etc/selinux/config",
                        "Ubuntu" => "/etc/selinux",
                },
                content => template("selinux/selinux.erb"),
        }
}
