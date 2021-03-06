define keepalived::instance (
  $interface,
  $virtual_ips,
  $state,
  $priority,
  $track_script      = [],
  $mcast_src_ip      = undef,
  $notify_script     = undef,
  $notify_master     = undef,
  $notify_backup     = undef,
  $notify_fault      = undef,
  $smtp_alert        = false,
  $nopreempt         = false,
  $advert_int        = '1',
  $auth_type         = undef,
  $auth_pass         = undef,
  $virtual_router_id = $name,
  $virtual_routes    = [],
) {

  validate_array( $virtual_ips,
    $track_script,
    $virtual_routes )

  include keepalived::variables

  Keepalived::Vrrp_script[ regsubst($track_script, '^(.+) weight .*', '\1') ] -> Keepalived::Instance[ $name ]

  concat::fragment { "keepalived_${name}":
    target  => $keepalived::variables::keepalived_conf,
    content => template( 'keepalived/keepalived_instance.erb' ),
    order   => '50',
    notify  => Class[ 'keepalived::service' ],
    require => Class[ 'keepalived::install' ],
  }
}
