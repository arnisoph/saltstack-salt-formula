salt:
  lookup:
    master:
      config: |
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

          ext_pillar:
           - git: master git@host:/srv/path/saltpillar.git
    minion:
      pkgs:
        - salt-minion
{% if salt['grains.get']('os') == 'Debian' %}
        - python-mysqldb
        - python-apt
        - lsb-release
{% endif %}
