salt:
  lookup:
    minion:
      config:
        log_level: debug
        file_client: local
        file_roots:
          base:
            - /srv/salt/states
            - /srv/salt/contrib/states
        pillar_roots:
          base:
            - /srv/salt/pillar
        module_dirs:
          - /srv/salt/_modules
