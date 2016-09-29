#Encapsulates policy and rule classes.
#Can disable postrun_facts and control_rules.
#"rule_key" value used to identify key name that stores firewall rules in Hiera.
class windows_firewall (
    $profile_state = 'on',
    $in_policy = 'BlockInbound',
    $out_policy = 'AllowOutbound',
    $purge_rules = false,
    $rule_key = 'windows_networks',
    )
{
    if $::osfamily == 'windows' {
        $firewall_name = 'MpsSvc'

        service { 'windows_firewall':
            ensure => 'running',
            name   => $firewall_name,
            enable => true,
        }->
        class { 'windows_firewall::profile':
            profile_state => $profile_state,
        }->
        class { 'windows_firewall::policy':
            in_policy  => $in_policy,
            out_policy => $out_policy,
        }->
        class { 'windows_firewall::rule':
            rule_key  => $rule_key,
        }->
        resources { 'firewall_rule':
            purge => $purge_rules,
        }
    }
    else {
        notify {"${::osfamily} not supported": }
    }
}
