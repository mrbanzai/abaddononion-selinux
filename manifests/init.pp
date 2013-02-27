class selinux( $state, $type ) {

        package { "selinux":
                name => $::operatingsystem ? {
                        "CentOS" => "selinux-policy",
                        "RedHat" => "selinux-policy",
                        "Fedora" => "selinux-policy",
                        "OracleLinux" => "selinux-policy",
                        # Need to figure out the package name here on ubuntu
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
                        "Fedora" => "/etc/selinux/config",
                        "OracleLinux" => "/etc/selinux/config",
                        "Ubuntu" => "/etc/selinux",
                },
                content => template("selinux/selinux.erb"),
        }
}
