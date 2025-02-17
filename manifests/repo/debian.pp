# @summary Set up the apt repo on Debian-based distros
# @api private
class jenkins::repo::debian (
  String $gpg_key_id = '63667EE74BBA1F0A08A698725BA31D57EF5975CA',
) {
  assert_private()

  include apt
  $keyring_local_path = '/usr/share/keyrings/jenkins-keyring.asc'

  if $jenkins::lts {
    $location = "${jenkins::repo::base_url}/debian-stable"
  } else {
    $location = "${jenkins::repo::base_url}/debian"
  }

  exec { 'install-apt-key-for-jenkins':
    command => '/usr/bin/wget -O ${keyring_local_path} ${location}/${jenkins::repo::gpg_key_filename}',
  }

# apt::key { 'jenkins':
#   id      => '63667EE74BBA1F0A08A698725BA31D57EF5975CA',
#   server  => 'pgp.mit.edu',
# }

   apt::source { 'jenkins':
     location   => $location,
     release    => 'binary/',
     repos      => '',
     keyring    => "${keyring_local_path}",
     include    => {
       'src'       => false,
     },
 #   key        => {
 #       'id'     => $gpg_key_id,
 #       'source' => "${location}/${jenkins::repo::gpg_key_filename}",
 #   },
   }

}
