salt:
  lookup:
    master:
      config:
        file_roots:
          base:
            - /srv/salt/states/base
          prod:
            - /srv/salt/states/prod
          stage:
            - /srv/salt/states/stage
          dev:
            - /srv/salt/states/dev

        pillar_roots:
          base:
            - /srv/salt/pillar
    minion:
      pkgs:
        - salt-minion
{% if salt['grains.get']('os') == 'Debian' %}
        - python-mysqldb
        - python-apt
        - lsb-release
{% endif %}
