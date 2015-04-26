salt:
  lookup:
    master:
      pkgs: []
      config:
        master:
          config:
            autosign_file: /etc/salt/autosign.conf

            file_roots:
              base:
                - /srv/salt/states
                - /srv/salt/contrib/states
                - /vagrant/share

            pillar_roots:
              base:
                - /srv/salt/pillar/examples
                - /srv/salt/pillar/share
    minion:
      pkgs: []
      config:
        minion:
          config:
            log_level: debug
            #file_client: local
            master: 127.0.0.1
            file_roots:
              base:
                - /srv/salt/states
                - /srv/salt/contrib/states
                - /vagrant/share
            pillar_roots:
              base:
                - /srv/salt/pillar/examples
                - /srv/salt/pillar/share
            module_dirs:
              - /srv/salt/_modules/common
              - /srv/salt/_modules/formulas
    ssh:
      config:
        roster:
          config:
            ipm1200.domain.de:
              host: 42.42.42.42
              user: root
              priv: /root/.ssh/cloud

cloud:
  update_cachedir: True
  diff_cache_events: True
  change_password: True
  providers:
    linode01:
      apikey: key
      password: pass
      provider: linode
    do01:
      #personal_access_token: key
      api_key: key
      client_key: key
      password: pass
      ssh_key_name: root@vagrant2
      ssh_key_file: /root/.ssh/cloud
      provider: digital_ocean
  profiles:
    linode_1024:
      provider: linode01
      size: Linode 1024
      image: Debian 7
      location: london
      script: 'true'
    do_512_fra:
      provider: do01
      size: 512MB
      image: 10322059
      location: 10
      script: 'true'
      private_networking: true
      ipv6: true

ssh:
  lookup:
    client:
      config:
        ssh_config:
          template_path: False
    server:
      config:
        sshd_config:
          template_path: False
  keys:
    manage:
      users:
        root_cloud_keypair:
          name: root
          keysize: 4096
          prvfile: /root/.ssh/cloud
          pubfile: /root/.ssh/cloud.pub
