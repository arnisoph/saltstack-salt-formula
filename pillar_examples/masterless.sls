salt:
  lookup:
    minion:
      pkgs: []
      config:
        minion:
          config:
            log_level: debug
            file_client: local
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
